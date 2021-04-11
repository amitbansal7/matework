require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Matework
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1
    config.web_console.whitelisted_ips = ['192.168.31.8', '192.168.1.6', '192.168.1.7']
    config.action_cable.allowed_request_origins = [/http:\/\/*/, /https:\/\/*/, /file:\/\/*/, 'file://', nil]



    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    config.eager_load_paths << Rails.root.join("services")
    config.eager_load_paths << Rails.root.join("serializers")
  end
end
