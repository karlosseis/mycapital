require 'test_helper'

class MovementsControllerTest < ActionController::TestCase
  setup do
    @movement = movements(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:movements)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create movement" do
    assert_difference('Movement.count') do
      post :create, movement: { account_id: @movement.account_id, amount: @movement.amount, location_id: @movement.location_id, movement_date: @movement.movement_date, movementtype_id: @movement.movementtype_id, name: @movement.name, subcategory_id: @movement.subcategory_id, user_id: @movement.user_id }
    end

    assert_redirected_to movement_path(assigns(:movement))
  end

  test "should show movement" do
    get :show, id: @movement
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @movement
    assert_response :success
  end

  test "should update movement" do
    patch :update, id: @movement, movement: { account_id: @movement.account_id, amount: @movement.amount, location_id: @movement.location_id, movement_date: @movement.movement_date, movementtype_id: @movement.movementtype_id, name: @movement.name, subcategory_id: @movement.subcategory_id, user_id: @movement.user_id }
    assert_redirected_to movement_path(assigns(:movement))
  end

  test "should destroy movement" do
    assert_difference('Movement.count', -1) do
      delete :destroy, id: @movement
    end

    assert_redirected_to movements_path
  end
end
