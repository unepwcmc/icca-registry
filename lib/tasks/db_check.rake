namespace :db_check do
  desc "Checks to see if your DB is valid prior to ActiveStorage installation and if files are completely up to date"
  task :import => :environment do |t|
     def download(target)
        s3 = AWS::S3.new(
          :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
          :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'])



        if target == 'db'
          target_object = s3.buckets["#{ENV['AWS_BUCKET']}"].objects.with_prefix("#{ENV["AWS_BUCKET_#{target.upcase}"]}").to_a.last

          FileUtils.mkdir_p('temp')

          File.open("temp/#{target}.tar", 'wb') do |file|
            puts 'File will be downloaded to a temp folder in your Rails app'
            target_object.read do |chunk|
              file.write(chunk)
            end
          end

          puts 'Killing all db connections and dropping the old database...'
           tasks = %w(db_check:kill_db_connections db:drop db:create db_check:unzip_and_import)
            tasks.each do |t|
              puts "Running #{t}..."
              Rake::Task[t].invoke([target]) if t == tasks[3]
              Rake::Task[t].invoke
            end
        else
          return if target.empty?
          photos = s3.buckets["#{ENV["AWS_BUCKET_PRODUCTION"]}"].objects.with_prefix('photos/files/000/000/')
          photo_paths = []
          photos.to_a.each { |photo| photo_paths << photo.key }
          puts 'Downloading photos to your designated folder'

          union = photo_paths & target

          union.each_with_index do |filepath, index|
            photos.each do |photo|
              if photo.content_type =~ /^(image)/
                if Rails.env.staging?
                  root_url = "https://s3.amazonaws.com/#{ENV['AWS_BUCKET_STAGING']}"
                  dest_dir = FileUtils.mkdir_p(File.join(root_url, photo.key.split('/')[0..-2].join('/'))).first
                else
                  dest_dir = FileUtils.mkdir_p(File.join('public/system', photo.key.split('/')[0..-2].join('/'))).first
                end
                File.open(File.join(dest_dir, photo.key.split('/').last), 'wb') do |file|
                  photo.read do |chunk|
                    file.write(chunk)
                  end
                end
              end
            end
            break if index == union.size - 1
          end

          puts 'All missing photos downloaded'
        end
     end


    def file_check
      Rails.application.eager_load!
      models = ActiveRecord::Base.descendants.reject(&:abstract_class?)

      files_to_download = []


      models.each do |model|
        attachments = model.column_names.map do |c|
            if c =~ /(.+)_file_name$/
              $1
            end
          end.compact

          if attachments.blank?
            next
          end

          model.find_each.each do |instance|
            attachments.each do |attachment|
              if instance.send(attachment).path.blank? || !File.exist?(instance.send(attachment).path)
                files_to_download << instance.send(attachment).path.split('/').slice(6..-1).join('/') if !instance.send(attachment).path.nil?
              end
            end
          end
       end

       files_to_download
    end


    # First, download DB
    puts question = "Do you wish to download a new version of the database? Bear in mind your old one will be erased: Yes/No"
    answer = STDIN.gets.chomp
    until answer == 'Yes' || answer == 'No'
      puts question
      answer = STDIN.gets.chomp
    end

    if answer.downcase.capitalize == 'Yes'
      download('db')
      download(file_check)
    else
      puts "Checking your files..."
      puts "Downloading any files needed"
      download(file_check)
    end

  end

  desc "Kills all active connections of your current database"
  task :kill_db_connections => :environment do
      db = "icca_registry_#{Rails.env}"
      sh = <<~EOF
    ps xa \
      | grep postgres: \
      | grep #{db} \
      | grep -v grep \
      | awk '{print $1}' \
      | xargs kill
    EOF
      puts "#{sh}"
  end

  desc "Fetches data from latest backup bucket and imports it into your app"
  task :unzip_and_import, [:filename] => :environment do |task, args|
    %x[ tar -xvzf temp/#{args[:filename][0]}.tar -C temp/ ]
    if args[:filename][0] == 'db'
      %x[ bzip2 -dk temp/icca_registry_daily/databases/PostgreSQL.sql.bz2 ]
      puts 'Loading database into app...'
      %x[ psql icca_registry_#{Rails.env} < temp/icca_registry_daily/databases/PostgreSQL.sql  ]
      puts 'Database successfully copied over'
    end
  end
end





