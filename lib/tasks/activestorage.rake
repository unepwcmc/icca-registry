namespace :activestorage do
  desc "Local to local only: Copy over paperclip public/system files into ActiveStorage's storage folder"
  task :local_to_local => :environment do |t|
    ActiveStorage::Attachment.find_each do |attachment|
      name = attachment.name

      source = attachment.record.send(name).path
      dest_dir = File.join(
        "storage",
        attachment.blob.key.first(2),
        attachment.blob.key.first(4).last(2))
      dest = File.join(dest_dir, attachment.blob.key)

      FileUtils.mkdir_p(dest_dir)
      puts "Moving #{source} to #{dest}"
      FileUtils.cp(source, dest)
    end
  end

  desc "Local to AWS: Copy over paperclip public/system files into AWS bucket"
  task :local_to_aws => :environment do |t|
      models = ActiveRecord::Base.descendants.reject(&:abstract_class?)

      models.each do |model|
        attachments = model.column_names.map do |c|
          if c =~ /(.+)_file_name$/
            $1
          end
        end.compact

        attachments.each do |attachment|
          model.where.not("#{attachment}_file_name": nil).find_each do |instance|
            bucket = ENV["AWS_BUCKET_#{Rails.env.upcase}"]
            name = instance.send("#{attachment}_file_name")
            content_type = instance.send("#{attachment}_content_type")
            id = instance.id

            url = "https://s3.amazonaws.com/#{bucket}/uploads/#{attachment.pluralize}/#{id}/original/#{name}"

            instance.send(attachment.to_sym).attach(
              io: open(url),
              filename: name,
              content_type: content_type
              )
          end
        end
      end
  end


  desc "AWS restructuring: reorganising paperclip file structure into one suited for ActiveStorage"
  task :aws_restructure => :environment do |t|

  end
end
