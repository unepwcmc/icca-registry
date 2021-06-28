namespace :db_check do
  desc 'Checks to see if your DB is valid prior to ActiveStorage installation and if files are completely up to date'
  task import: :environment do |_t|
    @s3 = S3.new

    def download_s3_file(target, file)
      target.read { |chunk| file.write(chunk) }
    end

    def remove_temp_folder
      FileUtils.remove_dir('temp')
      puts 'Temp folder removed'
    end

    def download_db
      return 'You\'re in production - no download needed' if Rails.env.production?

      target_object = @s3.latest_backup
      name = target_object.key.split('/').last

      FileUtils.mkdir_p('temp')

      File.open("temp/#{name}", 'wb') do |file|
        puts 'File will be downloaded to a temp folder in your Rails app'
        download_s3_file(target_object, file)
      end

      puts 'Killing all db connections and dropping the old database...'
      tasks = %w(db_check:kill_db_connections db:drop db:create db:migrate db_check:unzip_and_import)
      tasks.each do |t|
        puts "Running #{t}..."
        Rake::Task[t].invoke([name]) if t == tasks[3]
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

      bucket = @s3.get_bucket(Rails.application.credentials.dig(:default, :production_db))

      missing_files.each do |file|
        file_path = "storage/#{file.slice(0..1)}/#{file.slice(2..3)}"
        FileUtils.mkdir_p(file_path)
        File.open(File.join(file_path, file), 'wb') do |f|
          begin
            download_s3_file(bucket.objects[file], f)
          rescue AWS::S3::Errors::NoSuchKey
            puts "No file with key: #{file} found in the bucket"
            next
          end
        end
      end
    end

    # This replaces the values for the hostnames of each site with localhost (as
    # they use the actual URLs in production)
    def change_host_sites
      Comfy::Cms::Site.find_each do |site|
        site.update(hostname: 'localhost:3000')
      end
    end

    # First, download DB
    puts question = "
    Do you wish to download a new version of the database?
    Bear in mind your old one will be erased: Yes/No
    "
    answer = STDIN.gets.chomp
    until answer == 'Yes' || answer == 'No'
      puts question
      answer = STDIN.gets.chomp
    end

    download_db if answer.downcase.capitalize == 'Yes'
    puts 'Checking your files...'
    puts 'Downloading any files needed'
    check_for_missing_files
    change_host_sites
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
    abort('No db found') unless args[:filename][0] == 'icca_registry_daily.tar'
    ` tar -xvzf temp/#{args[:filename][0]} -C temp/ `
    ` bzip2 -dk temp/icca_registry_daily/databases/PostgreSQL.sql.bz2 `
    puts 'Loading database into app...'
    ` psql icca_registry_#{Rails.env} < temp/icca_registry_daily/databases/PostgreSQL.sql`
    puts 'Database successfully copied over'
  end
end
