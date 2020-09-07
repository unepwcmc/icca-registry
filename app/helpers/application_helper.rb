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

  def get_news_items all = false
    news_page = @cms_site.pages.find_by_slug('news-and-stories')
    published_pages = news_page.children.published
    sorted_cards = published_pages.sort_by { |c| c.fragments.where(identifier: 'published_date').first.datetime }.reverse

    @items = {
      title: news_page.label,
      url: all ? false : get_cms_url(news_page.full_path),
      cards: all ? sorted_cards : sorted_cards.first(2)
    }
  end

  def get_cms_url path
    root_path + path
  end
end
