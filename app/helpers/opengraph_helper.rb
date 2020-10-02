module OpengraphHelper
  include ApplicationHelper

  # TODO - temporary methods for handling @cms_page.nil? cases
  def og_description
    return t('social.fallback_description') if @cms_page.nil?
    desc = cms_fragment_content(:summary, @cms_page)
    desc.blank? ? t('social.fallback_description') : desc
  end

  def og_image
    fallback_hero
  end

  def og_image_alt
    return t('social.fallback_image_alt') if @cms_page.nil?
    @cms_page.parent.label == 'News and Stories' ? t('social.image_alt') : t('social.fallback_image_alt')
  end

  def og_title
    return t('social.fallback_title') if @cms_page.nil?
    title = cms_fragment_content(:label, @cms_page)
    title.blank? ? t('social.fallback_title') : title
  end

  def og_type
    return 'website' if @cms_page.nil?
    @cms_page.parent.label == 'News and Stories' ? 'article' : 'website'
  end

  def og_url
    # TODO - Check this works in production...
    request.url
  end
end