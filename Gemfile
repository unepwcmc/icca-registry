source 'https://rubygems.org'

# Frameworks
# gem 'rails', git: 'https://github.com/rails/rails/', branch: '5-2-stable'
gem 'rails', '~> 5.2.4.3'
gem 'comfortable_mexican_sofa', '~> 2.0.0'
gem 'nokogiri', '~> 1.6.7.2'
gem 'dotenv-rails', require: 'dotenv/rails-now'
gem 'aws-sdk', '~> 1.6'
# Accessing S3 bucket using AWS gem instead of open-uri
gem 'aws-sdk-s3'
gem 'appsignal', '~> 2.2.1'
gem 'invisible_captcha'
gem 'paperclip'

# Assets
gem 'sassc-rails', '~> 1.3.0'
gem 'sassc', '~> 1.9'
gem 'turbolinks'
gem 'comfy_bootstrap_form', '~> 4.0.3'
gem 'webpacker'
# Needed to load in custom JS into the CMS - added back in
gem 'coffee-rails'

# DB
gem 'pg', '~> 0.18.4'
gem 'pg_search'

group :development, :test do
  gem 'byebug'
  gem 'letter_opener'
  gem 'rspec-rails', '~> 3.9'
end

group :development do
  gem 'web-console'
  gem 'spring'
  gem 'capistrano-rvm',   '~> 0.1', require: false
  gem 'capistrano', '3.11.0', require: false
  gem 'capistrano-rails',   '~> 1.1', require: false
  gem 'capistrano-bundler', '~> 1.6.0', require: false
  gem 'capistrano-passenger', '~> 0.1.1', require: false
end

