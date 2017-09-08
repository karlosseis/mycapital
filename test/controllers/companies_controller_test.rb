require 'test_helper'

class CompaniesControllerTest < ActionController::TestCase
  setup do
    @company = companies(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:companies)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create company" do
    assert_difference('Company.count') do
      post :create, company: { ampliated_sum: @company.ampliated_sum, average_price: @company.average_price, average_price_origin_currency: @company.average_price_origin_currency, date_share_price: @company.date_share_price, dividend_sum: @company.dividend_sum, estimated_benefit_global_currency: @company.estimated_benefit_global_currency, estimated_value_global_currency: @company.estimated_value_global_currency, invested_sum: @company.invested_sum, name: @company.name, perc_estimated_benefit_global_currency: @company.perc_estimated_benefit_global_currency, puchased_sum: @company.puchased_sum, quantity_ampliated: @company.quantity_ampliated, quantity_puchased: @company.quantity_puchased, quantity_sold: @company.quantity_sold, search_symbol: @company.search_symbol, sector_id: @company.sector_id, share_price: @company.share_price, share_price_global_currency: @company.share_price_global_currency, shares_sum: @company.shares_sum, sold_sum: @company.sold_sum, stockexchange_id: @company.stockexchange_id, symbol: @company.symbol, user_id: @company.user_id }
    end

    assert_redirected_to company_path(assigns(:company))
  end

  test "should show company" do
    get :show, id: @company
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @company
    assert_response :success
  end

  test "should update company" do
    patch :update, id: @company, company: { ampliated_sum: @company.ampliated_sum, average_price: @company.average_price, average_price_origin_currency: @company.average_price_origin_currency, date_share_price: @company.date_share_price, dividend_sum: @company.dividend_sum, estimated_benefit_global_currency: @company.estimated_benefit_global_currency, estimated_value_global_currency: @company.estimated_value_global_currency, invested_sum: @company.invested_sum, name: @company.name, perc_estimated_benefit_global_currency: @company.perc_estimated_benefit_global_currency, puchased_sum: @company.puchased_sum, quantity_ampliated: @company.quantity_ampliated, quantity_puchased: @company.quantity_puchased, quantity_sold: @company.quantity_sold, search_symbol: @company.search_symbol, sector_id: @company.sector_id, share_price: @company.share_price, share_price_global_currency: @company.share_price_global_currency, shares_sum: @company.shares_sum, sold_sum: @company.sold_sum, stockexchange_id: @company.stockexchange_id, symbol: @company.symbol, user_id: @company.user_id }
    assert_redirected_to company_path(assigns(:company))
  end

  test "should destroy company" do
    assert_difference('Company.count', -1) do
      delete :destroy, id: @company
    end

    assert_redirected_to companies_path
  end
end
