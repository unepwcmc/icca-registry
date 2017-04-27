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
```
git clone https://github.com/unepwcmc/icca-registry.git icca-registry
cd icca-registry
bundle install
bundle exec rake db:create db:migrate
bundle exec rake bower:install
```

icca-registry uses the `dotenv` gem to manage environment variables. Before
starting the server, create a copy of the file `.env.example` (removing the
`.example` bit) and edit the needed variables. After this final step, `bundle
exec rails server` should work like a charm.
