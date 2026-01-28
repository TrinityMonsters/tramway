# frozen_string_literal: true

require File.expand_path('dummy/config/environment', __dir__)

require 'spec_helper'
require 'rspec/rails'
require 'view_component/test_helpers'
require 'view_component/system_test_helpers'
require 'capybara/rspec'
require 'faker'
require 'tramway/helpers/navbar_helper'
require 'tramway/navbar'
require 'factory_bot_rails'
require 'webdrivers/chromedriver'
require 'database_cleaner/active_record'
require 'support/web_driver_helper'
require 'support/theme_helper'
require 'support/multiselect_helpers'

RSpec.configure do |config|
  config.use_active_record = false
  config.include ViewComponent::TestHelpers, type: :component
  config.include ViewComponent::SystemTestHelpers, type: :component
  config.include Capybara::RSpecMatchers, type: :component
  config.include Capybara::RSpecMatchers, type: :view
  config.include Capybara::RSpecMatchers, type: :controller
  config.include Capybara::RSpecMatchers, type: :decorator
  config.include FactoryBot::Syntax::Methods
  config.include ThemeHelper
  config.include MultiselectHelpers

  config.use_transactional_fixtures = false
end

Capybara.register_driver :headless_chrome do |app|
  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    options: Selenium::WebDriver::Chrome::Options.new(args: %w[headless disable-gpu no-sandbox disable-dev-shm-usage])
  )
end

Capybara.javascript_driver = :headless_chrome

Capybara.register_driver :headless_chrome_mobile do |app|
  mobile_options = Selenium::WebDriver::Chrome::Options.new(args: %w[headless disable-gpu no-sandbox
                                                                     disable-dev-shm-usage])
  mobile_options.add_argument('--window-size=375,812') # iPhone X dimensions

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    options: mobile_options
  )
end
