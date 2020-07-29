ICCA Registry - CMS upgrade to 2.0.17
===========================

The ICCA Registry website is an online information platform for Indigenous and
Community Conserved Areas, where communities themselves provide data, case
studies, maps, photos and stories which result in useful statistics and
analysis on featured ICCAs around the world.

# Installation

icca-registry is a pretty standard Rails application, backed by a Postgres
database, using bower to load the protectedplanet-frontend framework.
Part 1:

- `git clone https://github.com/unepwcmc/icca-registry.git icca-registry`
- `cd icca-registry`
- `bundle install`
- get a copy of the latest .env file
- `rails db:create`

Note that this branch now utilises Ruby version 2.3.1, and Rails v.5.2.4.3.

- In `photo.rb` and `resource.rb` in `app/models`, comment out lines 4-5 and uncomment out line 2

- `rake db_check:import` - to download latest DB from the server (if you are setting up this version of the project for the first time) and downloads latest photos as well. You will have to delete all Comfy::Cms::File records in the database (they are safe to delete as their attached files do not exist on disk and will not be downloaded from the bucket) if you want to access the 'Files' section of the CMS. Follow the instructions below. 

- `rake db:migrate`

- `rake migrate:to_activestorage`

- `rake activestorage:paperclip_to_activestorage` to copy all Paperclip files to the ActiveStorage location specified in the config file, whether local or remote. 

- Uncomment out lines 4-5 of `photo.rb` and `resource.rb` to let the app use ActiveStorage, and comment out line 2 in each case (don't delete just in case something goes wrong and you need to revert back to using Paperclip). Now the photos should load on each page.

- `yarn install`

- Start the server.

icca-registry uses the `dotenv` gem to manage environment variables. Before
starting the server, create a copy of the file `.env.example` (removing the
`.example` bit) and edit the needed variables. After this final step, `rails server` should work like a charm.

## Known issues
-  Potentially you may encounter a 404 error when trying to access the Explore page via your localhost. In that instance, access the CMS admin interface via `localhost:3000/admin`, visit Sites and manually alter the hostname and path of each site to `localhost:3000` and locale respectively, where locale is en/es/fr for the three languages.
- If at any point, either during or after DB migration, you experience an error with the format `... was delegated to attachment, but attachment is nil`, this issue is caused by the use of a database dump with attached CMS files that do not exist locally, thus Rails either cannot locate the file, or there are records present for files which are missing in reality. First, double check whether you have all files from production available in the correct location and:

1) Re-run the migration. 

Or if you successfully migrated, but your app breaks on accessing the Files section of the CMS:

2) Access the Rails console via `rails console`. The relevant table you will want to inspect is `Comfy::Cms::File`. Run the command `Comfy::Cms::File.all.pluck(:file_file_name)` and cross-check with the Paperclip file names that you have locally in `public/system`. If you cannot find any, run the command `Comfy::Cms::File.destroy_all`, which delete all of the records in the database for that table, leaving you able to access the page. If you'd rather not utilise a dangerous method such as the one above, you can manually delete selected records using `Comfy::Cms::File.where(file_file_name: [filename, make sure to put it in quotation marks]).destroy`. 

If it breaks upon accessing a page (which shouldn't really happen), the table to be accessed is `Comfy::Cms::Page` for pages, and `Comfy::Cms::Fragment` for individual ICCA case studies.

# Adding Translations

To add another language you will need to clone an existing site (best to use the english site) from within the cms. Make sure you check the *mirrored* box to mirror all the same layouts from the english site. By default, comfy will copy the layouts and snippets but their content will be empty causing the site to error.To get around this, there is a rake task that you can run to import the content from the english version to your new locale by passing in the symbol of your new locale...

To copy from English site to Spanish:

```ruby
rake comfy:copy_layout_to_new_site[:es]
```

Don't forget to add the locale file too in `config/locales`



