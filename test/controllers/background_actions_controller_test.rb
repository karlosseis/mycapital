require 'test_helper'

class BackgroundActionsControllerTest < ActionController::TestCase
  test "should get create_company" do
    get :create_company
    assert_response :success
  end

end
