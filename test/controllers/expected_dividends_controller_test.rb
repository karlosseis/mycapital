require 'test_helper'

class ExpectedDividendsControllerTest < ActionController::TestCase
  setup do
    @expected_dividend = expected_dividends(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:expected_dividends)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create expected_dividend" do
    assert_difference('ExpectedDividend.count') do
      post :create, expected_dividend: { amount: @expected_dividend.amount, company_id: @expected_dividend.company_id, currency_id: @expected_dividend.currency_id, operation_date: @expected_dividend.operation_date, operationtype_id: @expected_dividend.operationtype_id, origin_amount: @expected_dividend.origin_amount, origin_price: @expected_dividend.origin_price, origin_price_unit: @expected_dividend.origin_price_unit, price_unit: @expected_dividend.price_unit, quantity: @expected_dividend.quantity, user_id: @expected_dividend.user_id }
    end

    assert_redirected_to expected_dividend_path(assigns(:expected_dividend))
  end

  test "should show expected_dividend" do
    get :show, id: @expected_dividend
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @expected_dividend
    assert_response :success
  end

  test "should update expected_dividend" do
    patch :update, id: @expected_dividend, expected_dividend: { amount: @expected_dividend.amount, company_id: @expected_dividend.company_id, currency_id: @expected_dividend.currency_id, operation_date: @expected_dividend.operation_date, operationtype_id: @expected_dividend.operationtype_id, origin_amount: @expected_dividend.origin_amount, origin_price: @expected_dividend.origin_price, origin_price_unit: @expected_dividend.origin_price_unit, price_unit: @expected_dividend.price_unit, quantity: @expected_dividend.quantity, user_id: @expected_dividend.user_id }
    assert_redirected_to expected_dividend_path(assigns(:expected_dividend))
  end

  test "should destroy expected_dividend" do
    assert_difference('ExpectedDividend.count', -1) do
      delete :destroy, id: @expected_dividend
    end

    assert_redirected_to expected_dividends_path
  end
end
