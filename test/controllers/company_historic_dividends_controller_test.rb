require 'test_helper'

class CompanyHistoricDividendsControllerTest < ActionController::TestCase
  setup do
    @company_historic_dividend = company_historic_dividends(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:company_historic_dividends)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create company_historic_dividend" do
    assert_difference('CompanyHistoricDividend.count') do
      post :create, company_historic_dividend: { amount: @company_historic_dividend.amount, announce_date: @company_historic_dividend.announce_date, company_id: @company_historic_dividend.company_id, dividend_type: @company_historic_dividend.dividend_type, exdividend_date: @company_historic_dividend.exdividend_date, float: @company_historic_dividend.float, payment_Date: @company_historic_dividend.payment_Date, record_date: @company_historic_dividend.record_date, user_id: @company_historic_dividend.user_id }
    end

    assert_redirected_to company_historic_dividend_path(assigns(:company_historic_dividend))
  end

  test "should show company_historic_dividend" do
    get :show, id: @company_historic_dividend
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @company_historic_dividend
    assert_response :success
  end

  test "should update company_historic_dividend" do
    patch :update, id: @company_historic_dividend, company_historic_dividend: { amount: @company_historic_dividend.amount, announce_date: @company_historic_dividend.announce_date, company_id: @company_historic_dividend.company_id, dividend_type: @company_historic_dividend.dividend_type, exdividend_date: @company_historic_dividend.exdividend_date, float: @company_historic_dividend.float, payment_Date: @company_historic_dividend.payment_Date, record_date: @company_historic_dividend.record_date, user_id: @company_historic_dividend.user_id }
    assert_redirected_to company_historic_dividend_path(assigns(:company_historic_dividend))
  end

  test "should destroy company_historic_dividend" do
    assert_difference('CompanyHistoricDividend.count', -1) do
      delete :destroy, id: @company_historic_dividend
    end

    assert_redirected_to company_historic_dividends_path
  end
end
