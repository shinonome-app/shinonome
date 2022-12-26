# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 7.0.2', '>= 7.0.2.3'

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem 'sprockets-rails'

# Use Puma as the app server
gem 'puma', '~> 6.0'

# Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem 'jsbundling-rails'

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails'

# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 5.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

# Use PostgreSQL instead of Sqlite3
gem 'pg'

# Use I18n
gem 'rails-i18n'

# Component system for Rails
gem 'view_component'

# Authentication based on Rack/Warden
# gem 'devise'
gem 'devise'
# gem 'devise', git: 'https://github.com/heartcombo/devise', branch: 'main'

# Pagination in views
gem 'pagy'

# Use TailswindCSS
gem 'tailwindcss-rails'

# Some libraries use rexml as XML processor
gem 'rexml'

# Makes dummy data for seeds
gem 'faker'
gem 'gimei'

gem 'dotenv-rails'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri mingw x64_mingw]

  # Annotate models with DB
  gem 'annotate'

  # Fake mail system on web
  gem 'letter_opener_web', '~> 2.0'

  # Ruby static analytics and lint
  gem 'rubocop'
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false

  # Makes zipped bookdata for seeds
  gem 'rubyzip'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.1.0'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'listen', '~> 3.3'
  gem 'rack-mini-profiler', '~> 3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 3.26'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'

  # Use Rspec instead of MiniTest
  gem 'rspec-rails'

  # Support tools with Rspec
  gem 'factory_bot_rails'
  gem 'test-prof'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

gem 'erb_lint', '~> 0.3.0', require: false

gem 'aozora2html', '~> 3.0'
