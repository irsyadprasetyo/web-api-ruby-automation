Before '@seit' do |scenario|
  require_relative 'api_dunia'
  include ApiDunia
  get_global_api_address
  $scenario_name = scenario.feature.name
  page.driver.browser.manage.window.resize_to(1370, 768)
end

After do |scenario|
  case ENV['REPORT']
    when 'RUN'
      ReportBuilder.input_path = "reports/cucumber.json"

      ReportBuilder.configure do |config|
        config.report_path = "reports/run"
        config.report_types = [:json, :html]
      end

    when 'RERUN'
      ReportBuilder.input_path = "reports/rerun_reports/cucumber.json"

      ReportBuilder.configure do |config|
        config.report_path = "reports/rerun_reports/rerun"
        config.report_types = [:json, :html]
      end

    when 'RETRY_RERUN'
      ReportBuilder.input_path = "reports/rerun_reports/retry/cucumber.json"

      ReportBuilder.configure do |config|
        config.report_path = "reports/rerun_reports/retry/retry-rerun"
        config.report_types = [:json, :html]
      end

    else
      # print 'case not matching'
  end

  if(scenario.failed?)
    #Do something if scenario fails.
  end
end
