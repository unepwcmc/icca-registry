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
    image = cms_fragment_render(:hero_image, @cms_page)

    return image unless image.blank?
    image_path('hero_image_news-and-stories.jpg')
  end

  # Strip html tags
  def parse_html_content(content)
    Nokogiri::HTML(content).css("p").first.text rescue "No description available."
  end

  # For the news article cards
  def get_news_card_attributes(cards)
    # Maximum length of the attributes (in characters)
    summary_length = 200
    title_length = 59

    cards.map.with_index do |card, index|
    {
      key: index,
      date: cms_fragment_content_datetime(:published_date, card).strftime("%d %B %y"),
      image: cms_fragment_render(:hero_image, card),
      summary: truncate(parse_html_content(cms_fragment_content(:summary, card)), length: summary_length),
      title: card[:label].truncate(title_length, separator: ' '),
      url: get_cms_url(card[:full_path])
    }
    end
  end

  def sort_by_date(pages)
    pages.sort_by { |c| c.fragments.where(identifier: 'published_date').first.datetime }.reverse
  end

  def sorted_news_articles
    news_page = @cms_site.pages.find_by_slug('news-and-stories')
    published_pages = news_page.children.published
    { page: news_page, cards: sort_by_date(published_pages) }
  end

  # News articles partial
  def get_news_items
    news = sorted_news_articles

    @items = {
      title: news[:page].label,
      url: get_cms_url(news[:page].full_path),
      cards: get_news_card_attributes(news[:cards].first(2))
    }
  end

  # For infinite scroll on news index page
  def get_initial_news_pages
    size = NewsSerializer::DEFAULT_PAGE_SIZE

    _options = {
      page: 1,
      size: size
    }
    pages = sort_by_date(@cms_page.children.where(is_published: true))

    NewsSerializer.new(pages, _options).serialize
  end

  def get_cms_url(path)
    locale_root_url(locale: I18n.locale.to_s).concat(path)
  end

  #  article's attached files
  def get_resources
    resources = @cms_page.resources

    resources.map do |resource|
      next unless resource.file.present?
      {
        button: I18n.t('global.button.download'),
        title: resource.label,
        url: url_for(resource.file)
      }
    end
  end

  def cms_fragment_content_datetime(identifier, page)
    # Might not be able to find that particular tag and identifier combo -  hence the try
    date = page.fragments.find_by(tag: 'date_not_null', identifier: identifier).try(:datetime)
    date ? date : cms_fragment_content(identifier, page)
  end
end
