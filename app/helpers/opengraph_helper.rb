module OpengraphHelper
  include ApplicationHelper

  def og_description
    return t('social.fallback_description') if cms_fragment_content(:summary, @cms_page).blank?
    cms_fragment_content(:summary, @cms_page)
  end

  def og_image
    fallback_hero
  end

  def og_title
    return t('social.fallback_title') if cms_fragment_content(:label, @cms_page).blank?
    cms_fragment_content(:label, @cms_page)
  end

  def og_type
    @cms_page.parent.label == 'News and Stories' ? 'article' : 'website' 
  end

  def og_url
    request.absolute_url
  end
end