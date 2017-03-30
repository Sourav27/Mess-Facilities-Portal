require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MessFacilitiesPortal
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    #config.action_controller.relative_url_root = "/mess-facilities"
    config.time_zone = 'Chennai'
    config.active_record.default_timezone = :local
  end
end
