namespace :activestorage do
  task :reattach_files => :environment do |t|
    files_directory = Rails.root.join("public/system/files")
    Dir.children(files_directory).each do |f|
      Dir.children(files_directory.join("#{f}/original")).each do |file| 
        comfy_file = Comfy::Cms::File.find(Integer(f))
        local_path = files_directory.join("#{f}/original/#{file}")
        puts "Attaching #{local_path} to File #{f}"
        comfy_file.attachment.attach io: File.open(local_path), filename: comfy_file.file_file_name
      rescue ActiveRecord::RecordNotFound
        warn "Did not find Comfy::Cms::File #{f}"
      end
    end
  end

   # You should have a valid .env before attempting this task - it will obviously fail otherwise!
   desc "Paperclip to ActiveStorage: Copy over paperclip public/system files into ActiveStorage's storage folder"
   task :paperclip_to_activestorage => :environment do |t|
    def upload_to_s3(source, attachment, s3)
      bucket = s3.buckets["#{ENV["AWS_BUCKET_#{Rails.env.upcase}"]}"]
    
      target_object = bucket.objects[attachment.blob.key]

      target_object.write(Pathname.new(source))
    end

    s3 = AWS::S3.new(
      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'])

    ActiveStorage::Attachment.find_each do |attachment|
      next if attachment.record.nil?

      name = attachment.name

      # Skips Comfy::Cms::Files which are not covered by the migration
      next if name == 'attachment'

      # Generating the Paperclip file path if Paperclip's already been uninstalled 
      id = attachment.record_id
      id = '0' + id.to_s if id < 100
      filename = attachment.blob.filename
      source = "public/system/#{attachment.record_type.downcase.pluralize}/files/000/000/#{id}/original/#{filename}"        
      next unless File.exist?(source)

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
        upload_to_s3(source, attachment, s3)
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
