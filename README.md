ICCA Registry
===========================

# Installation

icca-registry is a pretty standard Rails application, backed by a Postgres database. To install icca-registry, proceed with the usual commands:
```
git clone https://github.com/unepwcmc/icca-registry.git icca-registry
cd icca-registry
bundle install
bundle exec rake db:create db:migrate
```

icca-registry uses the `dotenv` gem to manage environment variables. Before starting the server, create a copy of the file `.env.example` (removing the `.example` bit) and edit the needed variables. After this final step, `bundle exec rails server` should work like a charm.
