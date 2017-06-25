require 'test_helper'

class PlanifRecordsControllerTest < ActionController::TestCase
  setup do
    @planif_record = planif_records(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:planif_records)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create planif_record" do
    assert_difference('PlanifRecord.count') do
      post :create, planif_record: { account_id: @planif_record.account_id, amount: @planif_record.amount, day: @planif_record.day, end_at: @planif_record.end_at, name: @planif_record.name, periodicity_id: @planif_record.periodicity_id, start_at: @planif_record.start_at, start_month: @planif_record.start_month, subcategory_id: @planif_record.subcategory_id, user_id: @planif_record.user_id }
    end

    assert_redirected_to planif_record_path(assigns(:planif_record))
  end

  test "should show planif_record" do
    get :show, id: @planif_record
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @planif_record
    assert_response :success
  end

  test "should update planif_record" do
    patch :update, id: @planif_record, planif_record: { account_id: @planif_record.account_id, amount: @planif_record.amount, day: @planif_record.day, end_at: @planif_record.end_at, name: @planif_record.name, periodicity_id: @planif_record.periodicity_id, start_at: @planif_record.start_at, start_month: @planif_record.start_month, subcategory_id: @planif_record.subcategory_id, user_id: @planif_record.user_id }
    assert_redirected_to planif_record_path(assigns(:planif_record))
  end

  test "should destroy planif_record" do
    assert_difference('PlanifRecord.count', -1) do
      delete :destroy, id: @planif_record
    end

    assert_redirected_to planif_records_path
  end
end
