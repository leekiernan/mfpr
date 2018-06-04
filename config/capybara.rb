require "capybara"
require "selenium-webdriver"

Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end


# Capybara.javascript_driver = :headless_chrome
# Capybara.javascript_driver = :chrome
Capybara.javascript_driver = :selenium_chrome_headless

Capybara.configure do |config|
  config.default_max_wait_time = 10
  config.default_driver    = :selenium_chrome_headless
  # config.default_driver    = :selenium
end
