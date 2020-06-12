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

  desc "Update CMS content/layout tagging syntax to 2.0 standard"
  task :update_cms_tags => :environment do |t|
  Comfy::Cms::Layout.all.each do |layout|
    layout.content = layout.content.gsub(/\{\{ ?cms:page:([\w\/]+) ?\}\}/, '{{ cms:text \1 }}') if layout.content.is_a? String

    # {{cms:page:page_header:string}} -> {{ cms:text page_header }}
    layout.content = layout.content.gsub(/\{\{ ?cms:page:([\w]+):string ?\}\}/, '{{ cms:text \1 }}') if layout.content.is_a? String

    # {{cms:page:content:rich_text}} -> {{ cms:wysiwyg content }}
    layout.content = layout.content.gsub(/\{\{ ?cms:page:([\w]+):rich_text ?\}\}/, '{{ cms:wysiwyg \1 }}') if layout.content.is_a? String
    layout.content = layout.content.gsub(/\{\{ ?cms:page:([\w\/-]+):rich_text ?\}\}/, '{{ cms:wysiwyg \1 }}') if layout.content.is_a? String
    layout.content = layout.content.gsub(/\{\{ ?cms:page:([\w]+):([^:]*) ?\}\}/, '{{ cms:\2 \1 }}') if layout.content.is_a? String
    layout.content = layout.content.gsub(/\{\{ ?cms:field:([\w]+):string ?\}\}/, '{{ cms:text \1, render: false }}') if layout.content.is_a? String
    layout.content = layout.content.gsub(/\{\{ ?cms:field:([\w]+):([^:]*) ?\}\}/, '{{ cms:\2 \1, render: false }}') if layout.content.is_a? String

    # {{ cms:partial:main/homepage }} -> {{ cms:partial "main/homepage" }}
        layout.content = layout.content.gsub(/\{\{ ?cms:asset:([\w\/-]+):([\w\/-]+):([\w\/-]+) ?\}\}/, '{{ cms:asset \1 type: \2 as: tag}}') if layout.content.is_a? String
        layout.content = layout.content.gsub(/\{\{ ?cms:partial:([\w\/]+) ?\}\}/, '{{ cms:partial \1 }}') if layout.content.is_a? String
        layout.content = layout.content.gsub(/\{\{ ?cms:(\w+):([\w\/-]+) ?\}\}/, '{{ cms:\1 \2 }}') if layout.content.is_a? String
        layout.content = layout.content.gsub(/\{\{ ?cms:(\w+):([\w\/-]+):([\w\/-]+):([\w\/-]+) ?\}\}/, '{{ cms:\1 \2 \3 \4}}') if layout.content.is_a? String
        layout.content = layout.content.gsub(/\{\{ ?cms:(\w+):([\w]+):([^:]*) ?\}\}/, '{{ cms:\1 \2, "\3" }}') if layout.content.is_a? String
        layout.content = layout.content.gsub(/cms:rich_text/, 'cms:wysiwyg') if layout.content.is_a? String
        layout.content = layout.content.gsub(/cms:integer/, 'cms:number') if layout.content.is_a? String
        layout.content = layout.content.gsub(/cms: string/, 'cms:text') if layout.content.is_a? String # probably a result of goofing one of the more general regexps
        layout.content = layout.content.gsub(/\{\{ ?cms:page_file ([\w\/]+) ?\}\}/, '{{ cms:file \1, render: false }}') if layout.content.is_a? String
        layout.content = layout.content.gsub(/<!-- {{ cms:text (\w+)_slide, render: false }} -->/, "{{ cms:text \1, render: false }}") if layout.content.is_a? String

    layout.save if layout.changed?
  end
  Comfy::Cms::Fragment.all.each do |fragment|
    # {{ cms:partial:main/homepage }} -> {{ cms:partial "main/homepage" }}
    fragment.datetime = fragment.updated_at if fragment.datetime.nil?
    fragment.content = fragment.content.gsub(/\{\{ ?cms:partial:([\w\/]+) ?\}\}/, '{{ cms:partial \1 }}') if fragment.content.is_a? String

    fragment.content = fragment.content.gsub(/\{\{ ?cms:page:([\w]+):string ?\}\}/, '{{ cms:text \1 }}') if fragment.content.is_a? String
    fragment.content = fragment.content.gsub(/\{\{ ?cms:page:([\w]+):rich_text ?\}\}/, '{{ cms:wysiwyg \1 }}') if fragment.content.is_a? String

    fragment.content = fragment.content.gsub(/\{\{ ?cms:page:([\w\/]+) ?\}\}/, '{{ cms:text \1 }}') if fragment.content.is_a? String
    fragment.content = fragment.content.gsub(/\{\{ ?cms:page:([\w]+):([^:]*) ?\}\}/, '{{ cms:\2 \1 }}') if fragment.content.is_a? String
    fragment.content = fragment.content.gsub(/\{\{ ?cms:field:([\w]+):([^:]*) ?\}\}/, '{{ cms:\2 \1, render: false }}') if fragment.content.is_a? String

    fragment.content = fragment.content.gsub(/\{\{ ?cms:(\w+):([\w]+) ?\}\}/, '{{ cms:\1 \2 }}') if fragment.content.is_a? String
    fragment.content = fragment.content.gsub(/\{\{ ?cms:(\w+):([\w]+):([^:]*) ?\}\}/, '{{ cms:\1 \2, "\3" }}') if fragment.content.is_a? String
    fragment.save if fragment.changed?
  end

  # With the change from Block to Fragment, Revision.data hash keys need to be updated
  Comfy::Cms::Revision.all.each do |revision|
    if revision.data['blocks_attributes'].present?
      revision.data['fragments_attributes'] = revision.data['blocks_attributes']
      revision.data.delete('blocks_attributes')
      revision.save
    end
  end
end
end
