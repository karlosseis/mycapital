require 'test_helper'

class ReferenceWebsControllerTest < ActionController::TestCase
  setup do
    @reference_web = reference_webs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:reference_webs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create reference_web" do
    assert_difference('ReferenceWeb.count') do
      post :create, reference_web: { name: @reference_web.name, url: @reference_web.url, user_id: @reference_web.user_id }
    end

    assert_redirected_to reference_web_path(assigns(:reference_web))
  end

  test "should show reference_web" do
    get :show, id: @reference_web
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @reference_web
    assert_response :success
  end

  test "should update reference_web" do
    patch :update, id: @reference_web, reference_web: { name: @reference_web.name, url: @reference_web.url, user_id: @reference_web.user_id }
    assert_redirected_to reference_web_path(assigns(:reference_web))
  end

  test "should destroy reference_web" do
    assert_difference('ReferenceWeb.count', -1) do
      delete :destroy, id: @reference_web
    end

    assert_redirected_to reference_webs_path
  end
end
