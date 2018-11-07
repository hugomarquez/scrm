require 'test_helper'

class Core::DashboardControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get core_dashboard_index_url
    assert_response :success
  end

end
