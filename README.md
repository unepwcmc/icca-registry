ICCA Registry - CMS upgrade to 2.0.17
===========================

The ICCA Registry website is an online information platform for Indigenous and
Community Conserved Areas, where communities themselves provide data, case
studies, maps, photos and stories which result in useful statistics and
analysis on featured ICCAs around the world.

# Installation

icca-registry is a pretty standard Rails application, backed by a Postgres
database, using bower to load the protectedplanet-frontend framework.
To install icca-registry, proceed with the usual commands:

- `git clone https://github.com/unepwcmc/icca-registry.git icca-registry`
- `cd icca-registry`
- get a copy of the .env file
- `bundle exec rake db:create`
- get an up-to-date production download of the DB and import `psql icca_registry_development < PATH/FILENAME.sql`. Despite technically being in the development environment, this will help to reduce the chance of an error derailing later steps below.

Only for this branch: 
Note that this branch now utilises Ruby version 2.3.1, and Rails v.5.2.4.3.
- get an __up-to-date__ production copy of the CMS files from the S3 bucket and place the folder into `icca-registry/public/system`. It is important to get the folder structure corresponding to the default storage location of Paperclip so that no errors occur during migration.
- `bundle install`
- `rails db:migrate` - to run migrations that create ActiveStorage tables, rename obsolete Comfy columns in the database and convert Paperclip attachments into ActiveStorage attachments.
- `bundle exec rake bower:install`
- Add `storage/` to your .gitignore, and remove `public/system`. 

There are also a number of `rake` tasks in `activestorage.rake` which will prove handy for creating backups of assets and so forth, either local or remotely via S3. 

icca-registry uses the `dotenv` gem to manage environment variables. Before
starting the server, create a copy of the file `.env.example` (removing the
`.example` bit) and edit the needed variables. After this final step, `rails server` should work like a charm.

## Known issues
-  Potentially you may encounter a 404 error when trying to access the Explore page via your localhost. In that instance, access the CMS admin interface via `localhost:3000/admin`, visit Sites and manually alter the hostname and path of each site to `localhost:3000` and locale respectively, where locale is en/es/fr for the three languages.
- If at any point, either during or after DB migration, you experience an error with the format `... was delegated to attachment, but attachment is nil`, this issue is caused by the use of a database dump with attached CMS files that do not exist locally, thus Rails either cannot locate the file, or there are records present for files which are missing in reality. First, double check whether you have all files from production available in the correct location and:

1) Re-run the migration. 

Or if you successfully migrated, but your app breaks on accessing the Files section of the CMS:

2) Access the Rails console via `rails console`. The relevant table you will want to inspect is `Comfy::Cms::File`. Run the command `Comfy::Cms::File.all.pluck(:file_file_name)` and cross-check with the Paperclip file names that you have locally. If you cannot find any, run the command `Comfy::Cms::File.destroy_all`, which delete all of the records in the database for that table, leaving you able to access the page. If you'd rather not utilise a dangerous method such as the one above, you can manually delete selected records using `Comfy::Cms::File.where(file_file_name: [filename, make sure to put it in quotation marks]).destroy`. 

If it breaks upon accessing a page (which shouldn't really happen), the table to be accessed is `Comfy::Cms::Page` for pages, and `Comfy::Cms::Fragment` for individual ICCA case studies.

# Adding Translations

To add another language you will need to clone an existing site (best to use the english site) from within the cms. Make sure you check the *mirrored* box to mirror all the same layouts from the english site. By default, comfy will copy the layouts and snippets but their content will be empty causing the site to error.To get around this, there is a rake task that you can run to import the content from the english version to your new locale by passing in the symbol of your new locale...

To copy from English site to Spanish:

```ruby
rake comfy:copy_layout_to_new_site[:es]
```

Don't forget to add the locale file too in `config/locales`



