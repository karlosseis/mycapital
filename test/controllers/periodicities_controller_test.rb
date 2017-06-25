require 'test_helper'

class PeriodicitiesControllerTest < ActionController::TestCase
  setup do
    @periodicity = periodicities(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:periodicities)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create periodicity" do
    assert_difference('Periodicity.count') do
      post :create, periodicity: { name: @periodicity.name, num_months: @periodicity.num_months, user_id: @periodicity.user_id }
    end

    assert_redirected_to periodicity_path(assigns(:periodicity))
  end

  test "should show periodicity" do
    get :show, id: @periodicity
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @periodicity
    assert_response :success
  end

  test "should update periodicity" do
    patch :update, id: @periodicity, periodicity: { name: @periodicity.name, num_months: @periodicity.num_months, user_id: @periodicity.user_id }
    assert_redirected_to periodicity_path(assigns(:periodicity))
  end

  test "should destroy periodicity" do
    assert_difference('Periodicity.count', -1) do
      delete :destroy, id: @periodicity
    end

    assert_redirected_to periodicities_path
  end
end
