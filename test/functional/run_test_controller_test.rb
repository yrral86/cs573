require 'test_helper'

class RunTestControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get start" do
    get :start
    assert_response :success
  end

  test "should get next" do
    get :next
    assert_response :success
  end

  test "should get finish" do
    get :finish
    assert_response :success
  end

end
