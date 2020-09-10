namespace :pgsearch do 
    desc "Rebuilds search documents for the CMS upgrade"
    task :rebuild => :environment do |t|
        PgSearch::Multisearch.rebuild(Comfy::Cms::Page)
        PgSearch::Multisearch.rebuild(Comfy::Cms::Fragment)
    end
end