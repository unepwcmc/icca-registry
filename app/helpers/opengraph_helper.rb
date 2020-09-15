module OpengraphHelper
  include ApplicationHelper

  def og_description
    desc = cms_fragment_content(:summary, @cms_page)
    desc.blank? ? t('social.fallback_description') : desc
  end

  def og_image
    fallback_hero
  end

  def og_title
    title = cms_fragment_content(:label, @cms_page)
    title.blank? ? t('social.fallback_title') : title
  end

  def og_type
    @cms_page.parent.label == 'News and Stories' ? 'article' : 'website'
  end

  def og_url
    # TODO - Check this works in production...
    request.url
  end
end