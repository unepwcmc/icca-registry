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

- `rails db:create`

- `rake db_check:import` - to download latest DB from the server (if you are setting up this version of the project for the first time) and downloads latest photos as well. 

- `rake db:migrate`

- `yarn install`

- Before starting the server, get a copy of the latest .env file.

- Start the server with `rails s`.

## Known issues
-  Potentially you may encounter a 404 error when trying to access the Explore page via your localhost. In that instance, access the CMS admin interface via `localhost:3000/admin`, visit Sites and manually alter the hostname and path of each site to `localhost:3000` and locale respectively, where locale is en/es/fr for the three languages.
- If at any point, either during or after DB migration, you experience an error with the format `... was delegated to attachment, but attachment is nil`, this issue is caused one of two things: Rails either cannot locate the file, even though it exists on your system, or there are records present for files which are missing in reality. To solve this, double check whether you have all files from production available in the correct location and run the rake task to reattach Comfy files - `rake activestorage:reattach_files` 

# Adding Translations

To add another language you will need to clone an existing site (best to use the english site) from within the cms. Make sure you check the *mirrored* box to mirror all the same layouts from the english site. By default, comfy will copy the layouts and snippets but their content will be empty causing the site to error.To get around this, there is a rake task that you can run to import the content from the english version to your new locale by passing in the symbol of your new locale...

To copy from English site to Spanish:

```ruby
rake comfy:copy_layout_to_new_site[:es]
```

Don't forget to add the locale file too in `config/locales`



