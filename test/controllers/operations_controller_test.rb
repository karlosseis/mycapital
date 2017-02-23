require 'test_helper'

class OperationsControllerTest < ActionController::TestCase
  setup do
    @operation = operations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:operations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create operation" do
    assert_difference('Operation.count') do
      post :create, operation: { amount: @operation.amount, comments: @operation.comments, commission: @operation.commission, company_id: @operation.company_id, currency_id: @operation.currency_id, destination_tax: @operation.destination_tax, exchange_rate: @operation.exchange_rate, fee: @operation.fee, gross_amount: @operation.gross_amount, net_amount: @operation.net_amount, operation_date: @operation.operation_date, operationtype_id: @operation.operationtype_id, origin_price: @operation.origin_price, price: @operation.price, quantity: @operation.quantity, user_id: @operation.user_id, withholding_tax: @operation.withholding_tax }
    end

    assert_redirected_to operation_path(assigns(:operation))
  end

  test "should show operation" do
    get :show, id: @operation
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @operation
    assert_response :success
  end

  test "should update operation" do
    patch :update, id: @operation, operation: { amount: @operation.amount, comments: @operation.comments, commission: @operation.commission, company_id: @operation.company_id, currency_id: @operation.currency_id, destination_tax: @operation.destination_tax, exchange_rate: @operation.exchange_rate, fee: @operation.fee, gross_amount: @operation.gross_amount, net_amount: @operation.net_amount, operation_date: @operation.operation_date, operationtype_id: @operation.operationtype_id, origin_price: @operation.origin_price, price: @operation.price, quantity: @operation.quantity, user_id: @operation.user_id, withholding_tax: @operation.withholding_tax }
    assert_redirected_to operation_path(assigns(:operation))
  end

  test "should destroy operation" do
    assert_difference('Operation.count', -1) do
      delete :destroy, id: @operation
    end

    assert_redirected_to operations_path
  end
end
