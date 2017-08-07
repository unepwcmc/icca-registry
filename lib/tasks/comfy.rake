namespace :comfy do
  desc "Populates a new foreign site with the content from the english language version"
  task copy_content_to_new_site: :environment do
    foreign_locale  = "es"
    foreign_site    = Comfy::Cms::Site.find_by_locale(foreign_locale)

    english_locale  = "en"
    english_site    = Comfy::Cms::Site.find_by_locale(english_locale)

    english_site.pages.each do |english_page|
      foreign_page = Comfy::Cms::Page.find_by_site_id_and_label(foreign_site.id, english_page.label)

      if foreign_page.present?
        # Empty foreign page of existing blocks
        foreign_page.blocks = []
        # Copy content blocks from english page to foreign page and set their id to that of the foreign page
        copied_english_blocks = english_page.blocks.map{|block| block.dup}
        # Add the duplicated blocks to the foreign page and save it
        foreign_page.blocks << copied_english_blocks
        foreign_page.save

        puts "Copied content from '#{english_page.label} (en)' to '#{foreign_page.label} (#{foreign_locale})'"
      end
    end

    puts "Done!"
  end
end
