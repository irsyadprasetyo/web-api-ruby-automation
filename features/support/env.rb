require 'cucumber/rails'
# ActionController::Base.allow_rescue = false
# begin
  # DatabaseCleaner.strategy = :transaction
  # DatabaseCleaner.clean
# rescue NameError
#   raise "You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it."
# end

# Cucumber::Rails::Database.javascript_strategy = :truncation'
require 'rspec/rails'
require 'capybara/rails'
require 'uri'
require 'capybara/rspec'
require 'rspec/retry'
require 'rspec/page-regression'
require 'selenium-webdriver'
Dotenv::Railtie.load

##========================================================================================================================##
##~----------------------------======--------------~ OS & Browser Section ~--------------======---------------------------~##
##========================================================================================================================##

bs_os = ENV['BS_OS'] || 'OS X'
bs_os_version = ENV['BS_OS_VERSION'] || 'El Capitan'
bs_browser = ENV['BROWSER']
bs_platform_name = "#{bs_os} #{bs_os_version}"

platform = ENV['BROWSER_PLATFORM']
browser_name = ENV['BROWSER_NAME']
browser_version = ENV['BROWSER_VERSION']
resolution = ENV['BROWSER_RESOLUTION']

#adding to support auto install webdriver
case bs_browser.downcase
  when 'chrome'
    require 'webdrivers/chromedriver'
  when 'firefox'
    require 'webdrivers/geckodriver'
  when 'edge'
    require 'webdrivers/edgedriver'
  else
    require 'webdrivers/chromedriver'
end

app_host, server_host, server_port, project, retry_times = case ENV['ENVIRONMENT']
 when 'pre-prod', 'pre-prod-sauce', 'pre-prod-coffee_cup'
   ['https://backoffice.mokapos.com', 'backoffice.mokapos.com', '80', nil, 1]
 when 'staging-sauce', 'staging-coffee_cup'
   ['https://backoffice-staging.mokapos.com', 'backoffice-staging.mokapos.com', '80', 'mokapos-staging', 3]
   ['https://backoffice.mokapos.com', 'backoffice.mokapos.com', '80', nil, 1]
 end

Capybara.app_host = app_host
Capybara.server_host = server_host
Capybara.server_port = server_port
Capybara.run_server = false
Capybara.default_max_wait_time = 30

default_driver, javascript_driver, remote_type = case ENV['ENVIRONMENT']
 when 'staging-coffee_cup'
   [:selenium, :selenium, 'coffee_cup']
 when 'prod-coffee_cup'
   [:selenium, :selenium, 'coffee_cup']
 when 'pre-prod-coffee_cup'
   [:selenium, :selenium, 'coffee_cup']
 when 'develop-coffee_cup'
   [:selenium, :selenium, 'coffee_cup']
 when 'simulation-coffee_cup'
   [:selenium, :selenium, 'coffee_cup']
 else
   [:selenium, :selenium, 'bs']
 end


Capybara.default_driver = default_driver
Capybara.javascript_driver = javascript_driver

module Capybara
  class << self
    attr_accessor :session_id, :remote_automation_platform
  end
end

Capybara.register_driver :selenium do |app|
  time = Time.new
  feature_name = $scenario_name
  caps = Selenium::WebDriver::Remote::Capabilities.new
  caps["browserName"] = ENV['BS_BROWSER']
  caps["version"] = "77.0"
  caps["enableVNC"] = true
  caps["enableVideo"] = true
  caps["videoName"] = "#{feature_name}-#{time.month}:#{time.day}.mpeg4"
  caps["name"] = "#{feature_name}:#{time.month}:#{time.day}"
  caps["screenResolution"] = ENV['RESOLUTION']
  caps["videoScreenSize"] = ENV['RESOLUTION']
  remote = ['simulation-coffee_cup', 'staging-coffee_cup', 'develop-coffee_cup', 'prod-coffee_cup', 'pre-prod-coffee_cup'].include?(ENV['ENVIRONMENT'])
  @driver = if remote
        case remote_type
          when 'sauce'
            Capybara::Selenium::Driver.new(app, {:browser => :chrome})
          when 'coffee_cup'
            Capybara::Selenium::Driver.new(app, :browser => :chrome ,url:"http://18.138.40.17:4444/wd/hub", desired_capabilities: caps)
          end
      else
        case bs_browser
          when 'Firefox'
            profile = Selenium::WebDriver::Firefox::Profile.new
            capabilities = Selenium::WebDriver::Remote::Capabilities.firefox(:firefox_profile => profile)
            Capybara::Selenium::Driver.new app, browser: bs_browser.downcase.to_sym, desired_capabilities: capabilities
          when 'Chrome'
            prefs = {
            }
            Capybara::Selenium::Driver.new app, detach: false, browser: bs_browser.downcase.to_sym, prefs: prefs
          else
            Capybara::Selenium::Driver.new app, browser: bs_browser.downcase.to_sym
          end
      end
end
