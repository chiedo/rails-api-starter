require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ExampleApp
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    # Set the web client URL so that the API knows where to point users to in it's responses that involve
    # a URL
    config.web_client_url = ENV["WEB_CLIENT_URL"] ? ENV["WEB_CLIENT_URL"] : 'http://localhost:4001'

    # Decides what generators to use. No generators for tests
    config.generators do |g|
      g.test_framework nil
    end

    # Allow for Rack Cors
    config.middleware.insert_before 0, "Rack::Cors" do
      allow do
        origins ENV["CORS_ALLOW_ORIGINS"] ? ENV["CORS_ALLOW_ORIGINS"] : '*'
        resource '*', :headers => :any, :methods => [:get, :post, :options, :put, :delete]
      end
    end
  end
end
