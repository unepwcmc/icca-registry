module SearchModule
  def self.results(term)
    results = Set.new
    PgSearch.multisearch(term).each do |result|
      if result.searchable_type == "Comfy::Cms::Fragment"
        results << result.searchable.record
      else
        results << result.searchable
      end
    end

    results.to_a
  end
end
