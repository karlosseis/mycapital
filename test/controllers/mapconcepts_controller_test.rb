require 'test_helper'

class MapconceptsControllerTest < ActionController::TestCase
  setup do
    @mapconcept = mapconcepts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:mapconcepts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create mapconcept" do
    assert_difference('Mapconcept.count') do
      post :create, mapconcept: { name: @mapconcept.name, subcategory_id: @mapconcept.subcategory_id, user_id: @mapconcept.user_id }
    end

    assert_redirected_to mapconcept_path(assigns(:mapconcept))
  end

  test "should show mapconcept" do
    get :show, id: @mapconcept
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @mapconcept
    assert_response :success
  end

  test "should update mapconcept" do
    patch :update, id: @mapconcept, mapconcept: { name: @mapconcept.name, subcategory_id: @mapconcept.subcategory_id, user_id: @mapconcept.user_id }
    assert_redirected_to mapconcept_path(assigns(:mapconcept))
  end

  test "should destroy mapconcept" do
    assert_difference('Mapconcept.count', -1) do
      delete :destroy, id: @mapconcept
    end

    assert_redirected_to mapconcepts_path
  end
end
