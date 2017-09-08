require 'test_helper'

class CompanyCommentsControllerTest < ActionController::TestCase
  setup do
    @company_comment = company_comments(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:company_comments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create company_comment" do
    assert_difference('CompanyComment.count') do
      post :create, company_comment: { comment: @company_comment.comment, company_id: @company_comment.company_id, url: @company_comment.url, user_id: @company_comment.user_id }
    end

    assert_redirected_to company_comment_path(assigns(:company_comment))
  end

  test "should show company_comment" do
    get :show, id: @company_comment
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @company_comment
    assert_response :success
  end

  test "should update company_comment" do
    patch :update, id: @company_comment, company_comment: { comment: @company_comment.comment, company_id: @company_comment.company_id, url: @company_comment.url, user_id: @company_comment.user_id }
    assert_redirected_to company_comment_path(assigns(:company_comment))
  end

  test "should destroy company_comment" do
    assert_difference('CompanyComment.count', -1) do
      delete :destroy, id: @company_comment
    end

    assert_redirected_to company_comments_path
  end
end
