require 'test_helper'

class BalancesControllerTest < ActionController::TestCase
  setup do
    @balance = balances(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:balances)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create balance" do
    assert_difference('Balance.count') do
      post :create, balance: { balance_date: @balance.balance_date, name: @balance.name, user_id: @balance.user_id }
    end

    assert_redirected_to balance_path(assigns(:balance))
  end

  test "should show balance" do
    get :show, id: @balance
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @balance
    assert_response :success
  end

  test "should update balance" do
    patch :update, id: @balance, balance: { balance_date: @balance.balance_date, name: @balance.name, user_id: @balance.user_id }
    assert_redirected_to balance_path(assigns(:balance))
  end

  test "should destroy balance" do
    assert_difference('Balance.count', -1) do
      delete :destroy, id: @balance
    end

    assert_redirected_to balances_path
  end
end
