require 'test_helper'

class EstimatedMovementsControllerTest < ActionController::TestCase
  setup do
    @estimated_movement = estimated_movements(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:estimated_movements)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create estimated_movement" do
    assert_difference('EstimatedMovement.count') do
      post :create, estimated_movement: { account_id: @estimated_movement.account_id, amount: @estimated_movement.amount, month_number: @estimated_movement.month_number, movement_date: @estimated_movement.movement_date, movementtype_id: @estimated_movement.movementtype_id, name: @estimated_movement.name, subcategory_id: @estimated_movement.subcategory_id, user_id: @estimated_movement.user_id }
    end

    assert_redirected_to estimated_movement_path(assigns(:estimated_movement))
  end

  test "should show estimated_movement" do
    get :show, id: @estimated_movement
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @estimated_movement
    assert_response :success
  end

  test "should update estimated_movement" do
    patch :update, id: @estimated_movement, estimated_movement: { account_id: @estimated_movement.account_id, amount: @estimated_movement.amount, month_number: @estimated_movement.month_number, movement_date: @estimated_movement.movement_date, movementtype_id: @estimated_movement.movementtype_id, name: @estimated_movement.name, subcategory_id: @estimated_movement.subcategory_id, user_id: @estimated_movement.user_id }
    assert_redirected_to estimated_movement_path(assigns(:estimated_movement))
  end

  test "should destroy estimated_movement" do
    assert_difference('EstimatedMovement.count', -1) do
      delete :destroy, id: @estimated_movement
    end

    assert_redirected_to estimated_movements_path
  end
end
