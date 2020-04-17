ICCA Registry
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
- get a download of the DB and import `psql icca_registry_development < PATH/FILENAME.sql` 
- get a copy of the cms files and place the `system` folder into `icca-registry/public`
- `bundle exec rake db:migrate`
- `bundle install`
- `bundle exec rake bower:install`

icca-registry uses the `dotenv` gem to manage environment variables. Before
starting the server, create a copy of the file `.env.example` (removing the
`.example` bit) and edit the needed variables. After this final step, `bundle
exec rails server` should work like a charm.

# Adding Translations

To add another language you will need to clone an existing site (best to use the english site) from within the cms. Make sure you check the *mirrored* box to mirror all the same layouts from the english site. By default, comfy will copy the layouts and snippets but their content will be empty causing the site to error.To get around this, there is a rake task that you can run to import the content from the english version to your new locale by passing in the symbol of your new locale...

To copy from English site to Spanish:

```ruby
rake comfy:copy_layout_to_new_site[:es]
```

Don't forget to add the locale file too in `config/locales`



