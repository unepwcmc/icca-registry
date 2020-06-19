namespace :migrate do
   # You should have a valid .env before attempting this task - it will obviously fail otherwise!
   desc "Use in case migration doesn't work"
   task :to_activestorage => :environment do |t|
      require 'open-uri'

        def make_active_storage_records(instance,attachment,model)
          blob_key = key(instance, attachment)
          filename = instance.send("#{attachment}_file_name")
          content_type = instance.send("#{attachment}_content_type")
          file_size = instance.send("#{attachment}_file_size")
          file_checksum = checksum(instance.send(attachment))
          created_at = instance.updated_at.iso8601

          blob_values = [blob_key, filename, content_type, file_size, file_checksum, created_at]

          ActiveRecord::Base.connection.raw_connection.exec_prepared(
            "active_storage_blob_statement",
            blob_values
            )

          blob_name = attachment
          record_type = model.name
          record_id = instance.id

          attachment_values = [blob_name, record_type, record_id, created_at]
          ActiveRecord::Base.connection.raw_connection.exec_prepared(
            "active_storage_attachment_statement",
            attachment_values
            )
        end

        get_blob_id = 'LASTVAL()'

        ActiveRecord::Base.connection.raw_connection.prepare("active_storage_blob_statement",<<-SQL)
        INSERT INTO active_storage_blobs (
        key, filename, content_type, metadata, byte_size, checksum, created_at
        ) VALUES ($1, $2, $3, '{}', $4, $5, $6)
        SQL

        ActiveRecord::Base.connection.raw_connection.prepare("active_storage_attachment_statement",<<-SQL)
        INSERT INTO active_storage_attachments (
        name, record_type, record_id, blob_id, created_at
          ) VALUES ($1, $2, $3, #{get_blob_id}, $4)
          SQL

          models = ActiveRecord::Base.descendants.reject(&:abstract_class?)

          models.each do |model|
            attachments = model.column_names.map do |c|
              if c =~ /(.+)_file_name$/
                $1
              end
            end.compact

            model.find_each.each do |instance|
              attachments.each do |attachment|
                make_active_storage_records(instance,attachment,model)
              end
            end
          end



        def key(instance, attachment)
        SecureRandom.uuid
        # Alternatively:
        # instance.send("#{attachment}").path
      end

      def checksum(attachment)
        # local files stored on disk:
        url = attachment.path
        Digest::MD5.base64digest(File.read(url))

        # remote files stored on another person's computer:
        # url = attachment.url
        # Digest::MD5.base64digest(Net::HTTP.get(URI(url)))
      end
  end
end
