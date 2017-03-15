require 'test_helper'

class BalanceDetailsControllerTest < ActionController::TestCase
  setup do
    @balance_detail = balance_details(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:balance_details)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create balance_detail" do
    assert_difference('BalanceDetail.count') do
      post :create, balance_detail: { account_id: @balance_detail.account_id, amount: @balance_detail.amount, balance_date: @balance_detail.balance_date, balance_id: @balance_detail.balance_id, name: @balance_detail.name, user_id: @balance_detail.user_id }
    end

    assert_redirected_to balance_detail_path(assigns(:balance_detail))
  end

  test "should show balance_detail" do
    get :show, id: @balance_detail
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @balance_detail
    assert_response :success
  end

  test "should update balance_detail" do
    patch :update, id: @balance_detail, balance_detail: { account_id: @balance_detail.account_id, amount: @balance_detail.amount, balance_date: @balance_detail.balance_date, balance_id: @balance_detail.balance_id, name: @balance_detail.name, user_id: @balance_detail.user_id }
    assert_redirected_to balance_detail_path(assigns(:balance_detail))
  end

  test "should destroy balance_detail" do
    assert_difference('BalanceDetail.count', -1) do
      delete :destroy, id: @balance_detail
    end

    assert_redirected_to balance_details_path
  end
end
