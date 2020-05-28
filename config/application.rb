require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module IccaRegistry
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :en

    config.autoload_paths += %W(#{config.root}/lib/modules)
    config.autoload_paths += %W(#{config.root}/app/presenters)

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    # Remove deprecation warnings on before callbacks halting callback chains on returning false
    ActiveSupport.halt_callback_chains_on_return_false = false

    # Rails 5 now supports per-form CSRF tokens to mitigate against code-injection attacks with forms created by JavaScript.
    # With this option turned on, forms in your application will each have their own CSRF token that is specific to the action and method for that form.
    config.action_controller.per_form_csrf_tokens = true

    # You can now configure your application to check if the HTTP Origin header should be checked against the site's origin as an additional CSRF defense.
    # Set the following in your config to true:
    config.action_controller.forgery_protection_origin_check = true

  end
end
