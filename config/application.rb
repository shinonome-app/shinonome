# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Shinonome
  # アプリクラス
  class Application < Rails::Application
    # ENVの文字列を変換する
    class EnvConverter
      def self.unescape_ustring(str)
        new.unescape_ustring(str)
      end

      def unescape_ustring(str)
        str.gsub(/\\u([0-9A-Fa-f]{4})/) { unescape_uchar(::Regexp.last_match(1)) }
      end

      def unescape_uchar(str)
        [str.to_i(16)].pack('U*')
      end
    end

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

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
    # config.action_view.field_error_proc = proc { |html_tag, _instance| content_tag :div, html_tag, class: 'p-1 bg-red-300 table' }

    config.x.main_site_url = ENV.fetch('MAIN_SITE_URL', nil)
    config.x.site_name = EnvConverter.unescape_ustring(ENV.fetch('SITE_NAME', 'Shinonome'))
    config.x.csv_dir = ENV.fetch('CSV_DIR', Rails.public_path.join('csv'))
    config.x.reception_email = ENV.fetch('RECEPTION_EMAIL', nil)

    # make enable assets pipeline
    # config.assets.enabled = true
  end
end
