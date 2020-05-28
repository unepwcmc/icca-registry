namespace :comfy do
  desc "Populates a new foreign site with the content from the english language version"
  task :copy_content_to_new_site, [:locale] => [:environment] do |t, args|
    foreign_locale  = args[:locale]
    foreign_site    = Comfy::Cms::Site.find_by_locale(foreign_locale)

    raise "Could not find site #{foreign_locale}" if foreign_site.nil?

    english_locale  = "en"
    english_site    = Comfy::Cms::Site.find_by_locale(english_locale)

    english_site.pages.each do |english_page|
      foreign_page = Comfy::Cms::Page.find_by_site_id_and_label(foreign_site.id, english_page.label)

      if foreign_page.present?
        # Empty foreign page of existing fragments
        foreign_page.fragments = []
        # Copy content fragments from english page to foreign page and set their id to that of the foreign page
        copied_english_fragments = english_page.fragments.map{|fragment| fragment.dup}
        # Add the duplicated fragments to the foreign page and save it
        foreign_page.fragments << copied_english_fragments
        foreign_page.save

        puts "Copied content from '#{english_page.label} (en)' to '#{foreign_page.label} (#{foreign_locale})'"
      end
    end

    puts "Done!"
  end

  desc "Copy layout html from english site to new site"
  task :copy_layout_to_new_site, [:locale] => [:environment] do |t, args|
    foreign_locale  = args[:locale]
    foreign_site    = Comfy::Cms::Site.find_by_locale(foreign_locale)

    raise "Could not find site #{foreign_locale}" if foreign_site.nil?

    english_locale  = "en"
    english_site    = Comfy::Cms::Site.find_by_locale(english_locale)

    foreign_layouts = Comfy::Cms::Layout.where(site: foreign_site.id)
    english_layouts = Comfy::Cms::Layout.where(site: english_site.id)

    english_layouts.each do |english_layout|
      # Find the corresponding foreign page or create it if it doesn't exist
      foreign_layout = foreign_layouts.find_by_identifier(english_layout.identifier)

      if foreign_layout.nil?
        puts "Cannot find #{foreign_locale} page for #{english_layout.identifier}, please create it first, then rerun this task"
      else
        foreign_layout.app_layout = english_layout.app_layout
        foreign_layout.content = english_layout.content
        foreign_layout.css = english_layout.css
        foreign_layout.js = english_layout.js
        foreign_layout.save!
        puts "Copied content from '#{english_layout.identifier} (en)' to '#{foreign_layout.identifier} (#{foreign_locale})'"
      end
    end
  end
end
