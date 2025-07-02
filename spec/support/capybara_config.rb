# frozen_string_literal: true

require 'capybara/rspec'
require 'selenium-webdriver'

# ChromeDriverの安定性向上のための設定
Capybara.register_driver :selenium_chrome_headless do |app|
  options = Selenium::WebDriver::Chrome::Options.new

  # ヘッドレスモード
  options.add_argument('--headless=new') # 新しいヘッドレスモード
  options.add_argument('--disable-gpu')

  # 安定性向上のための設定
  options.add_argument('--no-sandbox') # Dockerやサンドボックス環境での安定性
  options.add_argument('--disable-dev-shm-usage') # /dev/shmの問題を回避
  options.add_argument('--disable-extensions')
  options.add_argument('--disable-logging')
  options.add_argument('--disable-web-security') # CORS問題回避（テスト環境のみ）

  # パフォーマンス設定
  options.add_argument('--window-size=1400,2000')
  options.add_argument('--force-device-scale-factor=1')

  # メモリ使用量削減
  options.add_argument('--memory-pressure-off')
  options.add_argument('--enable-features=NetworkService,NetworkServiceInProcess')

  # クラッシュレポート無効化
  options.add_argument('--disable-crash-reporter')
  options.add_argument('--disable-background-timer-throttling')

  # ログ設定
  options.add_preference(:download, prompt_for_download: false)
  options.add_preference(:browser, set_download_behavior: { behavior: 'allow' })

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

# Capybaraの基本設定
Capybara.configure do |config|
  config.default_driver = :rack_test
  config.javascript_driver = :selenium_chrome_headless
  config.default_max_wait_time = 10 # タイムアウトを長めに設定

  # エラー時のスクリーンショット
  config.save_path = Rails.root.join('tmp/capybara')

  # サーバー設定
  config.server = :puma, { Silent: true } # Pumaのログを抑制
  config.server_port = 9887 + ENV['TEST_ENV_NUMBER'].to_i # 並列実行時のポート競合回避
end

# RSpecの設定
RSpec.configure do |config|
  # systemテストでのリトライ設定
  config.around(:each, type: :system) do |example|
    example.run_with_retry retry: 3, retry_wait: 1, exceptions_to_retry: [
      Net::ReadTimeout,
      Selenium::WebDriver::Error::TimeoutError,
      Selenium::WebDriver::Error::UnknownError,
      Selenium::WebDriver::Error::WebDriverError
    ]
  end

  # テスト前後のクリーンアップ
  config.before(:each, type: :system) do
    # ブラウザキャッシュのクリア
    Capybara.current_session.driver.browser.manage.delete_all_cookies if Capybara.current_driver == :selenium_chrome_headless
  end

  config.after(:each, type: :system) do |example|
    # 失敗時のスクリーンショット保存
    if example.exception && Capybara.current_driver == :selenium_chrome_headless
      timestamp = Time.current.strftime('%Y%m%d_%H%M%S')
      screenshot_name = "#{example.full_description.parameterize}_#{timestamp}.png"
      save_screenshot(screenshot_name) # rubocop:disable Lint/Debugger
      puts "\nScreenshot saved: tmp/capybara/#{screenshot_name}"
    end
  end
end
