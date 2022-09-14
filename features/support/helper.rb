require_relative 'helpers/automation_helper'
require_relative 'helpers/wait_for_ajax'
require_relative 'helpers/api_cleanup/cleanup_preparation'

module Helper
  include AutomationHelper
  include WaitForAjaxRequest
  include ApiCleanupData
end

World(Helper)
