class NewsSerializer
  include ActionView::Helpers::TextHelper
  include Rails.application.routes.url_helpers
  include Comfy::CmsHelper

  DEFAULT_PAGE_SIZE = 6.0

  DEFAULT_RESULT = {
    date: nil,
    title: '',
    url: '',
    summary: '',
    image: ''
  }.freeze

  def initialize(results, opts={})
    @results = results
    @options = opts
  end


  DEFAULT_OBJ = {
    total: 0,
    totalPages: 1,
    results: [DEFAULT_RESULT]
  }.freeze

  def serialize
    DEFAULT_OBJ.merge(
      {
        total: total,
        totalPages: total_pages,
        page: @options[:requested_page],
        size: @options[:items_per_page],
        results: sorted_pages.map do |record|
          {
            date: date(record),
            title: title(record[:label]),
            url: url(record[:full_path]),
            summary: summary(record),
            image: image(record)
          }
        end
      }
    ).to_json
  end

  private

  OLDEST_DATE = DateTime.new(0).freeze

  def sorted_pages
    return [] if @results.blank?
    @results.sort_by do |p|
      p.fragments.where(identifier: 'published_date').first.datetime
    end.reverse
  end

  def image(page)
    # TODO - double check that this works in production
    rails_blob_url(page.fragments.find_by(identifier: "hero_image").attachments.first, only_path: true)
  end

  def date(page)
    _date = cms_fragment_content(:published_date, page)
    _date.present? && _date.respond_to?(:strftime) ? _date.strftime('%d %B %y') : _date
  end

  def url(path)
    locale = I18n.locale.to_s
    site = Comfy::Cms::Site.find_by(locale: locale)
    !path.blank? ? site.hostname.concat("/#{locale}/").concat(path) : ''
  end

  def title(title)
    title_length = 59
    title.truncate(59, separator: ' ')
  end

  def summary(page)
    summary_length = 200
    _content = cms_fragment_content(:content, page)
    parsed_content = Nokogiri::HTML(_content).css("p").first.text rescue "No description available."
    truncate(parsed_content, length: summary_length)
  end

  def total
    @total ||= @results.count || 0
  end

  def total_pages
    (total / DEFAULT_PAGE_SIZE).ceil
  end
end