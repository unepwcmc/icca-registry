namespace :activestorage do
   # You should have a valid .env before attempting this task - it will obviously fail otherwise!
   desc "Paperclip to ActiveStorage: Copy over paperclip public/system files into ActiveStorage's storage folder"
   task :paperclip_to_activestorage => :environment do |t|
    def upload_to_s3(attachment, s3)
      bucket = s3.buckets["#{ENV["AWS_BUCKET_#{Rails.env.upcase}"]}"]

      blob_key_first = attachment.blob.key.first(2)
      blob_key_last = attachment.blob.key.first(4).last(2)
      url = "storage/#{blob_key_first}/#{blob_key_last}/#{attachment.blob.key}"
      target_object = bucket.objects[attachment.blob.key]

      target_object.write(Pathname.new(url))
    end

    s3 = AWS::S3.new(
      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'])

    ActiveStorage::Attachment.find_each do |attachment|
      name = attachment.name
      next if attachment.record.send(name).nil?

      if Gem::Specification::find_all_by_name('paperclip').any?
        source = attachment.record.send(name).path
        next if source.nil?
      else
        # If paperclip has already been uninstalled
        id = attachment.record_id
        id = '0' + id.to_s if id < 100
        filename = attachment.blob.filename
        # Replace if you require another file type
        filetype = "photos"
        source = "public/system/#{filetype}/files/000/000/#{id}/original/#{filename}"
      end

      storage_service = Rails.application.config.active_storage.service

      if storage_service == :local
        dest_dir = File.join(
          "storage",
          attachment.blob.key.first(2),
          attachment.blob.key.first(4).last(2))
        dest = File.join(dest_dir, attachment.blob.key)

        FileUtils.mkdir_p(dest_dir)
        puts "Moving #{source} to #{dest}"
        FileUtils.cp(source, dest)
      else
        upload_to_s3(attachment, s3)
      end
    end
  end

  # You should have a valid .env before attempting this task - it will obviously fail otherwise!
  desc "Copy paperclip files into a new folder structure (AWS) - this doesn't use ActiveStorage but simply keeps a copy of attached files"
  task :local_to_aws => :environment do |t|
    s3 = AWS::S3.new(
      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'])

    Rails.application.eager_load!
    models = ActiveRecord::Base.descendants.reject(&:abstract_class?)

    models.each do |model|
      attachments = model.column_names.map do |c|
        if c =~ /(.+)_file_name$/
          $1
        end
      end.compact

      attachments.each do |attachment|
        model.where.not("#{attachment}_file_name": nil).find_each do |instance|
          name = instance.send("#{attachment}_file_name")
          id = instance.id

          bucket = s3.buckets["#{ENV["AWS_BUCKET_#{Rails.env.upcase}"]}"]

          bucket.objects.each do |object|
            target_object = bucket.objects["files/#{id}/#{name}"]
            object.copy_to(target_object)
          end
        end
      end
    end
  end
end
