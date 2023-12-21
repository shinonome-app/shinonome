# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base # rubocop:disable Style/Documentation
  default from: Rails.application.config.x.reception_email || 'from@example.com'
  layout 'mailer'
end
