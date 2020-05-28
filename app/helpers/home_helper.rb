module HomeHelper
  def preview_page page
    raw = cms_fragment_content(:content, page)
    Nokogiri::HTML(raw).at_css("p").text.truncate(500) rescue "No preview available"
  end
end
