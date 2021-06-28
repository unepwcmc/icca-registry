namespace :activestorage do
  desc "Reattach files"
  task :reattach_files => :environment do |t|
    files_directory = Rails.root.join("public/system/comfy/cms/files/files/000/000")
    Dir.entries(files_directory).each do |f|
      next if f == '.' || f == '..'
      Dir.entries(files_directory.join("#{f}/original")).each do |file| 
        next if file == '.' || file == '..'
        begin
          comfy_file = Comfy::Cms::File.find(f.to_i)
          local_path = files_directory.join("#{f}/original/#{file}")
          puts "Attaching #{local_path} to File #{f}"
          comfy_file.attachment.attach io: File.open(local_path), filename: comfy_file.file_file_name
        rescue ActiveRecord::RecordNotFound
          warn "Did not find Comfy::Cms::File #{f}"
        end
      end
    end
  end
end
