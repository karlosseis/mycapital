require 'test_helper'

class ExpertTargetPricesControllerTest < ActionController::TestCase
  setup do
    @expert_target_price = expert_target_prices(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:expert_target_prices)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create expert_target_price" do
    assert_difference('ExpertTargetPrice.count') do
      post :create, expert_target_price: { company_id: @expert_target_price.company_id, date_target_price: @expert_target_price.date_target_price, target_price_1: @expert_target_price.target_price_1, target_price_2: @expert_target_price.target_price_2, url: @expert_target_price.url, web_name_id: @expert_target_price.web_name_id }
    end

    assert_redirected_to expert_target_price_path(assigns(:expert_target_price))
  end

  test "should show expert_target_price" do
    get :show, id: @expert_target_price
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @expert_target_price
    assert_response :success
  end

  test "should update expert_target_price" do
    patch :update, id: @expert_target_price, expert_target_price: { company_id: @expert_target_price.company_id, date_target_price: @expert_target_price.date_target_price, target_price_1: @expert_target_price.target_price_1, target_price_2: @expert_target_price.target_price_2, url: @expert_target_price.url, web_name_id: @expert_target_price.web_name_id }
    assert_redirected_to expert_target_price_path(assigns(:expert_target_price))
  end

  test "should destroy expert_target_price" do
    assert_difference('ExpertTargetPrice.count', -1) do
      delete :destroy, id: @expert_target_price
    end

    assert_redirected_to expert_target_prices_path
  end
end
