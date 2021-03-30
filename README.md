ICCA Registry 
===========================

The ICCA Registry website is an online information platform for Indigenous and
Community Conserved Areas, where communities themselves provide data, case
studies, maps, photos and stories which result in useful statistics and
analysis on featured ICCAs around the world.

# Installation

icca-registry is a pretty standard Rails application, backed by a Postgres
database, with Webpacker and Yarn to manage JS dependencies.

- `git clone https://github.com/unepwcmc/icca-registry.git icca-registry`
- `cd icca-registry`
- `bundle install`
- get a copy of the latest .env file
- `rails db:create`

- In `photo.rb` and `resource.rb` in `app/models`, comment out lines 4-5 and uncomment out line 2

- `rake db_check:import` - to download latest DB from the server (if you are setting up this version of the project for the first time) and downloads latest photos as well. 

- `rake db:migrate`

- `rake migrate:to_activestorage`

- `rake activestorage:paperclip_to_activestorage` to copy all Paperclip files to the ActiveStorage location specified in the config file, whether local or remote. 

- Uncomment out lines 4-5 of `photo.rb` and `resource.rb` to let the app use ActiveStorage, and comment out line 2 in each case (don't delete just in case something goes wrong and you need to revert back to using Paperclip). Now the photos should load on each page.

- `yarn install`

- Start the server.

Before
starting the server, create a copy of the file `.env.example` (removing the
`.example` bit) and edit the needed variables. After this final step, `rails server` should work like a charm.

## Known issues
-  Potentially you may encounter a 404 error when trying to access the Explore page via your localhost. In that instance, access the CMS admin interface via `localhost:3000/admin`, visit Sites and manually alter the hostname and path of each site to `localhost:3000` and locale respectively, where locale is en/es/fr for the three languages.
- If at any point, either during or after DB migration, you experience an error with the format `... was delegated to attachment, but attachment is nil`, this issue is caused one of two things: Rails either cannot locate the file, even though it exists on your system, or there are records present for files which are missing in reality. First, double check whether you have all files from production available in the correct location and:

1) Re-run the migration. 

Or if you successfully migrated, but your app breaks on accessing the Files section of the CMS:

2) Run the rake task to reattach Comfy files - `rake activestorage:reattach_files` 

# Adding Translations

To add another language you will need to clone an existing site (best to use the english site) from within the cms. Make sure you check the *mirrored* box to mirror all the same layouts from the english site. By default, comfy will copy the layouts and snippets but their content will be empty causing the site to error.To get around this, there is a rake task that you can run to import the content from the english version to your new locale by passing in the symbol of your new locale...

To copy from English site to Spanish:

```ruby
rake comfy:copy_layout_to_new_site[:es]
```

Don't forget to add the locale file too in `config/locales`

## Importing and exporting CMS seeds

Comfortable Mexican Sofa has a way of importing (and exporting) the pages, files, layouts etc. of existing content as seeds. This is handily encapsulated in a rake task, which can be run as follows:

If you don't already have the `cms` folder in your repository, this will be automatically created when you run the expor task. The following pair of commands relate to the English version of the site. 

`rake 'comfy:cms_seeds:export[icca-registry, icca_registry_seeds]'` to export the seed data to the `cms` folder
`rake 'comfy:cms_seeds:import[icca_registry_seeds, icca-registry]'` to import the seed data from the `cms` folder straight into your database so that it will fill the CMS with the latest content.

FR: 
`rake 'comfy:cms_seeds:export[icca-registry-fr, icca_registry_seeds-fr]'` to export the seed data to the `cms` folder
`rake 'comfy:cms_seeds:import[icca_registry_seeds-fr, icca-registry-fr]'` to import the seed data from the `cms` folder

ES: 
`rake 'comfy:cms_seeds:export[icca-registry-es, icca_registry_seeds-es]'` to export the seed data to the `cms` folder
`rake 'comfy:cms_seeds:import[icca_registry_seeds-es, icca-registry-es]'` to import the seed data from the `cms` folder

