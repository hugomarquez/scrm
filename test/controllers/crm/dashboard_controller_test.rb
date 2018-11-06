require 'test_helper'

class Crm::DashboardControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get crm_root_url
    assert_response :success
  end
end
