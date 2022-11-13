# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Shinonome
  # アプリクラス
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    config.autoload_paths << "#{root}/app/lib"

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.time_zone = 'Asia/Tokyo'
    config.i18n.default_locale = :ja
    config.active_record.default_timezone = :local

    # Modify error form class to support TailwindCSS
    config.action_view.field_error_proc = proc { |html_tag, _instance| content_tag :div, html_tag, class: 'field_with_errors p-1 bg-red-300 table' }

    config.x.main_site_url = ENV.fetch('MAIN_SITE_URL', nil)
    config.x.site_name = ENV.fetch('SITE_NAME', 'Shinonome')
  end
end
