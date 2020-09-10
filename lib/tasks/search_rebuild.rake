namespace :pgsearch do 
    desc "Rebuilds search documents for the CMS upgrade"
    task :rebuild => :environment do |t|
        PgSearch::Multisearch.rebuild(Comfy::Cms::Page)
        PgSearch::Document.where(searchable_type: "Comfy::Cms::Block").delete_all
    end
end