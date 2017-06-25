require 'test_helper'

class MovementtypesControllerTest < ActionController::TestCase
  setup do
    @movementtype = movementtypes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:movementtypes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create movementtype" do
    assert_difference('Movementtype.count') do
      post :create, movementtype: { name: @movementtype.name, user_id: @movementtype.user_id }
    end

    assert_redirected_to movementtype_path(assigns(:movementtype))
  end

  test "should show movementtype" do
    get :show, id: @movementtype
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @movementtype
    assert_response :success
  end

  test "should update movementtype" do
    patch :update, id: @movementtype, movementtype: { name: @movementtype.name, user_id: @movementtype.user_id }
    assert_redirected_to movementtype_path(assigns(:movementtype))
  end

  test "should destroy movementtype" do
    assert_difference('Movementtype.count', -1) do
      delete :destroy, id: @movementtype
    end

    assert_redirected_to movementtypes_path
  end
end
