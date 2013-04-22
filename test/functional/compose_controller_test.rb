require 'test_helper'

class ComposeControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get j48" do
    get :j48
    assert_response :success
  end

  test "should get randomforests" do
    get :randomforests
    assert_response :success
  end

  test "should get markov" do
    get :markov
    assert_response :success
  end

end
