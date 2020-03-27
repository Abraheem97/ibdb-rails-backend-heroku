require_relative 'boot'
require 'active_storage/engine'
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Ibdb
  class Application < Rails::Application
    config.assets.initialize_on_precompile = false
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    config.to_prepare do
      DeviseController.respond_to :html, :json
    end

    Rails.application.config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins ['https://ibdb-react-frontend.herokuapp.com']

        resource '*',
                 headers: :any,
                 methods: %i[get post put patch delete options head],
                 credentials: true
      end

      allow do
        origins ['https://ibdb-production.herokuapp.com']

        resource '*',
                 headers: :any,
                 methods: %i[get post put patch delete options head],
                 credentials: true
      end
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
