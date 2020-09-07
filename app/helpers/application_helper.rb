module ApplicationHelper
  def map_bounds protected_area=nil
    return Rails.application.credentials[Rails.env.to_sym][:default_map_bounds] unless protected_area

    {
      'from' => protected_area.bounds.first,
      'to' =>   protected_area.bounds.last
    }
  end

  def get_local_classes local_assigns
    (local_assigns.has_key? :classes) ? local_assigns[:classes] : ''
  end

  # Fallback hero image for individual news and articles page
  def fallback_hero
    image = cms_fragment_render(:image, @cms_page)
    
    return image unless image.blank?
    image_path('hero_image_news-and-stories.jpg')
  end
end
