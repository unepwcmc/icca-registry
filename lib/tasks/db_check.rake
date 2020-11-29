namespace :db_check do
  desc 'Checks to see if your DB is valid prior to ActiveStorage installation and if files are completely up to date'
  task import: :environment do |_t|
    def open_session
      AWS::S3.new(
        access_key_id: ENV['AWS_ACCESS_KEY_ID'],
        secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
      )
    end

    def remove_temp_folder
      FileUtils.remove_dir('temp')
      puts 'Temp folder removed'
    end

    def download_db
      return 'You\'re in production - no download needed' if Rails.env.production?
      s3 = open_session
      target_object = s3.buckets[ENV['AWS_BUCKET_BACKUP']].objects.with_prefix((ENV["AWS_BUCKET_DB"]).to_s).to_a.last

      FileUtils.mkdir_p('temp')

      File.open("temp/#{target}.tar", 'wb') do |file|
        puts 'File will be downloaded to a temp folder in your Rails app'
        target_object.read { |chunk| file.write(chunk) }
      end

      puts 'Killing all db connections and dropping the old database...'
      tasks = %w(db_check:kill_db_connections db:drop db:create db_check:unzip_and_import db:migrate)
      tasks.each do |t|
        puts "Running #{t}..."
        Rake::Task[t].invoke([target]) if t == tasks[3]
        Rake::Task[t].invoke
      end

      remove_temp_folder
    end

    def check_for_missing_files
      missing_files = []

      ActiveStorage::Attachment.find_each do |attachment|
        folder = attachment.blob.key.slice(0..1)
        sub_folder = attachment.blob.key.slice(2..3)
        
        file_path = File.join('storage', folder, sub_folder, attachment.blob.key)

        missing_files << attachment.blob.key unless File.exist?(file_path)
      end

      download_files(missing_files)
    end

    def download_files(missing_files)
      return 'No files are missing' if missing_files.empty?

      s3 = open_session

      bucket = s3.buckets[ENV['AWS_BUCKET_PRODUCTION']]

      missing_files.each do |file|
        folder = file.slice(0..1)
        sub_folder = file.slice(2..3)
        FileUtils.mkdir_p("storage/#{folder}/#{sub_folder}")
        File.open("storage/#{folder}/#{sub_folder}/#{file}", 'wb') do |f|
          begin
            bucket.objects[file].read { |chunk| f.write(chunk) }
          rescue AWS::S3::Errors::NoSuchKey
            puts "No file with key: #{file} found in the bucket"
            next
          end
        end
      end
    end


    # First, download DB
    puts question = "Do you wish to download a new version of the database?
	  Bear in mind your old one will be erased: Yes/No"
    answer = STDIN.gets.chomp
    until answer == 'Yes' || answer == 'No'
      puts question
      answer = STDIN.gets.chomp
    end

    download_db if answer.downcase.capitalize == 'Yes'
    puts 'Checking your files...'
    puts 'Downloading any files needed'
    check_for_missing_files
    puts 'Complete'
  end

  desc 'Kills all active connections of your current database'
  task kill_db_connections: :environment do
    db = "icca_registry_#{Rails.env}"
    kill_connections = <<-EOF
	ps xa \
	| grep postgres: \
	| grep #{db} \
	| grep -v grep \
	| awk '{print $1}' \
	| xargs kill
	EOF
    puts kill_connections.to_s
  end

  desc 'Fetches data from latest backup bucket and imports it into your app'
  task :unzip_and_import, [:filename] => :environment do |_task, args|
    return 'No db found' unless args[:filename][0] == 'db'
    ` tar -xvzf temp/#{args[:filename][0]}.tar -C temp/ `
    if args[:filename][0] == 'db'
      ` bzip2 -dk temp/icca_registry_daily/databases/PostgreSQL.sql.bz2 `
      puts 'Loading database into app...'
      ` psql icca_registry_#{Rails.env} < temp/icca_registry_daily/databases/PostgreSQL.sql  `
      puts 'Database successfully copied over'
    end
  end
end
