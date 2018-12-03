require 'test_helper'

class Core::TasksControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get core_tasks_index_url
    assert_response :success
  end

  test "should get new" do
    get core_tasks_new_url
    assert_response :success
  end

  test "should get edit" do
    get core_tasks_edit_url
    assert_response :success
  end

  test "should get create" do
    get core_tasks_create_url
    assert_response :success
  end

end
