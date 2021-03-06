namespace :db_check do
  desc 'Checks to see if your DB is valid prior to ActiveStorage installation and if files are completely up to date'
  task import: :environment do |_t|
    def download(target)
      s3 = AWS::S3.new(
        access_key_id: ENV['AWS_ACCESS_KEY_ID'],
        secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
      )

      if target == 'db'
        return 'You\'re in production - no download needed' if Rails.env.production?
        target_object = s3.buckets[(ENV['AWS_BUCKET']).to_s].objects.with_prefix((ENV["AWS_BUCKET_#{target.upcase}"]).to_s).to_a.last

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
      else
        return if target.empty?
        file_paths = []

        photos = s3.buckets[(ENV['AWS_BUCKET_PRODUCTION']).to_s].objects.with_prefix('photos/files/000/000/')
        resources = s3.buckets[(ENV['AWS_BUCKET_PRODUCTION']).to_s].objects.with_prefix('resources/files/000/000/')
        photos.to_a.each { |photo| file_paths << photo.key }
        resources.to_a.each { |resource| file_paths << resource.key }
        puts 'Downloading files to your designated folder'

        union = file_paths & target

        download_missing_files(photos, resources, union)
      end
    end

    def download_missing_files(photos, resources, missing_files)
      missing_files.each_with_index do |filepath, index|
        [photos, resources].each do |filetype|
          filetype.each do |path|
            next if filepath != path.key
            dest_dir = FileUtils.mkdir_p(File.join('public/system', path.key.split('/')[0..-2].join('/'))).first
            File.open(File.join(dest_dir, path.key.split('/').last), 'wb') do |file|
              path.read { |chunk| file.write(chunk) }
            end
          end
        end
        break if index == missing_files.size - 1
      end

      puts 'All missing files downloaded'
    end

    def file_check
      Rails.application.eager_load!
      models = ActiveRecord::Base.descendants.reject(&:abstract_class?)

      files_to_download = []

      models.each do |model|
        attachments = model.column_names.map do |c|
          Regexp.last_match(1) if c =~ /(.+)_file_name$/
        end.compact

        next if attachments.blank?

        model.find_each.each do |instance|
          attachments.each do |attachment|
            next unless instance.send(attachment).path.blank? || !File.exist?(instance.send(attachment).path)
            next if instance.send(attachment).path.nil?
            file_path = instance.send(attachment).path
            split_point = file_path.split('/').index(model.name.downcase)
            files_to_download << file_path.split('/').slice(split_point..-1).join('/')
          end
        end
      end

      files_to_download
    end

    # First, download DB
	puts question = """Do you wish to download a new version of the database? 
	Bear in mind your old one will be erased: Yes/No"""
    answer = STDIN.gets.chomp
    until answer == 'Yes' || answer == 'No'
      puts question
      answer = STDIN.gets.chomp
    end

    download('db') if answer.downcase.capitalize == 'Yes'
    puts 'Checking your files...'
    puts 'Downloading any files needed'
    download(file_check)
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
    ` tar -xvzf temp/#{args[:filename][0]}.tar -C temp/ `
    if args[:filename][0] == 'db'
      ` bzip2 -dk temp/icca_registry_daily/databases/PostgreSQL.sql.bz2 `
      puts 'Loading database into app...'
      ` psql icca_registry_#{Rails.env} < temp/icca_registry_daily/databases/PostgreSQL.sql  `
      puts 'Database successfully copied over'
    end
  end
end
