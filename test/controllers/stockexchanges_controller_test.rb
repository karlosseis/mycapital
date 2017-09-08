require 'test_helper'

class StockexchangesControllerTest < ActionController::TestCase
  setup do
    @stockexchange = stockexchanges(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:stockexchanges)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create stockexchange" do
    assert_difference('Stockexchange.count') do
      post :create, stockexchange: { country_id: @stockexchange.country_id, currency_id: @stockexchange.currency_id, name: @stockexchange.name }
    end

    assert_redirected_to stockexchange_path(assigns(:stockexchange))
  end

  test "should show stockexchange" do
    get :show, id: @stockexchange
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @stockexchange
    assert_response :success
  end

  test "should update stockexchange" do
    patch :update, id: @stockexchange, stockexchange: { country_id: @stockexchange.country_id, currency_id: @stockexchange.currency_id, name: @stockexchange.name }
    assert_redirected_to stockexchange_path(assigns(:stockexchange))
  end

  test "should destroy stockexchange" do
    assert_difference('Stockexchange.count', -1) do
      delete :destroy, id: @stockexchange
    end

    assert_redirected_to stockexchanges_path
  end
end
