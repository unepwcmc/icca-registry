namespace :pgsearch do 
    desc "Rebuilds search documents for the CMS upgrade"
    task :rebuild => :environment do |_t|
        PgSearch::Multisearch.rebuild(Comfy::Cms::Page)
        PgSearch::Document.where(searchable_type: 'Comfy::Cms::Block').destroy_all
        PgSearch::Multisearch.rebuild(Comfy::Cms::Fragment)
    end
end