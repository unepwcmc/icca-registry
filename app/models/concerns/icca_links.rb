module IccaLinks
  extend ActiveSupport::Concern



end



Comfy::Cms::Page.send(:include, IccaLinks)
