namespace :db_check do
  desc "Checks to see if your DB is valid prior to ActiveStorage installation and if files are completely up to date"
  task :check => :environment do |t|
    Rails.application.eager_load!
    models = ActiveRecord::Base.descendants.reject(&:abstract_class?)

     models.each do |model|
        # First, check if any missing records are present
        if model.all? { |instance| instance.send(attachment).exists? }
          puts "Your DB is not completely up to date. Downloading latest production DB from server..."
          download_db
        end

        # Secondly, identify if there are any missing files and download them!
        files_to_download = []


        model.find_each.each do |instance|
          attachments.each do |attachment|
            if instance.send(attachment).path.blank? || !File.exist?(instance.send(attachment).path)
              files_to_download << instance.send(attachment).path
            end
          end
        end

        download_files(files_to_download)
     end

     def download_db
        # TODO: Downloads production DB. Database for production needs to be on server!

     end

     def download_files(filepaths)
        return if filepaths.empty?

        s3 = AWS::S3.new(
          :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
          :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'])

        bucket = s3.buckets["#{ENV["AWS_BUCKET_#{Rails.env.upcase}"]}"]

        bucket.objects.each do |object|
          filepaths.each do |file_path|
            if file_path == object
              File.open(file_path, 'wb') do |file|
                bucket.objects[file_path].read do |chunk|
                  file.write(chunk)
                end
              end
            end
        end

      end
  end
end
