require 'test_helper'

class YahooTickersControllerTest < ActionController::TestCase
  setup do
    @yahoo_ticker = yahoo_tickers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:yahoo_tickers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create yahoo_ticker" do
    assert_difference('YahooTicker.count') do
      post :create, yahoo_ticker: { category: @yahoo_ticker.category, exchange: @yahoo_ticker.exchange, name: @yahoo_ticker.name, name_country: @yahoo_ticker.name_country, ticker: @yahoo_ticker.ticker }
    end

    assert_redirected_to yahoo_ticker_path(assigns(:yahoo_ticker))
  end

  test "should show yahoo_ticker" do
    get :show, id: @yahoo_ticker
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @yahoo_ticker
    assert_response :success
  end

  test "should update yahoo_ticker" do
    patch :update, id: @yahoo_ticker, yahoo_ticker: { category: @yahoo_ticker.category, exchange: @yahoo_ticker.exchange, name: @yahoo_ticker.name, name_country: @yahoo_ticker.name_country, ticker: @yahoo_ticker.ticker }
    assert_redirected_to yahoo_ticker_path(assigns(:yahoo_ticker))
  end

  test "should destroy yahoo_ticker" do
    assert_difference('YahooTicker.count', -1) do
      delete :destroy, id: @yahoo_ticker
    end

    assert_redirected_to yahoo_tickers_path
  end
end
