# frozen_string_literal: true

require 'lograge/sql/extension'

Rails.application.configure do
  if Rails.env.production?
    config.lograge.enabled = true
    config.lograge.formatter = Lograge::Formatters::Json.new
    # config.lograge.keep_original_rails_log = true
    # config.lograge.logger = ActiveSupport::Logger.new(Rails.root.join('log', "lograge-#{Rails.env}.log"))

    config.lograge.ignore_actions = ['HealthController#show']
  end
end
