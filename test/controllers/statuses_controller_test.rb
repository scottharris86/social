require 'test_helper'

class StatusesControllerTest < ActionController::TestCase
  setup do
    @status = statuses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:statuses)
  end

  test "should display all blocked users post when not logged in" do
    users(:blocked_friend).statuses.create(content: 'Blocked status')
    users(:steve).statuses.create(content: 'not blocked')
    get :index
    assert_match /not\ blocked/, response.body
    assert_match /Blocked\ status/, response.body
  end

  test "shouldnt display a blocked users post when logged in" do
    sign_in users(:scott)
    users(:blocked_friend).statuses.create(content: 'Blocked status')
    users(:steve).statuses.create(content: 'not blocked')
    get :index
    assert_match /not\ blocked/, response.body
    assert_no_match /Blocked\ status/, response.body
  end

  test "should be logged in to post status" do
    post :create, status: {content: "hello"}
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should be redirected when not logged in" do
    get :new
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should render the new page when logged in" do
    sign_in users(:scott)
    get :new
    assert_response :success
  end


  test "should create status when logged in" do
    sign_in users(:scott)
    assert_difference('Status.count') do
      post :create, status: { content: @status.content }
    end

    assert_redirected_to status_path(assigns(:status))
  end
  

  test "should create status for current user when logged in" do
    sign_in users(:scott)
    assert_difference('Status.count') do
      post :create, status: { content: @status.content, user_id: users(:steve).id }
    end
    assert_redirected_to status_path(assigns(:status))
    assert_equal assigns(:status).user_id, users(:scott).id
  end

  test "should show status" do
    get :show, id: @status
    assert_response :success
  end

  test "should get edit when logged in" do
    sign_in users(:scott)
    get :edit, id: @status
    assert_response :success
  end

  test "should redirect edit when not logged in" do
    get :edit, id: @status
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should update status when logged in" do
    sign_in users(:scott)
    patch :update, id: @status, status: { content: @status.content }
    assert_redirected_to status_path(assigns(:status))
  end

  test "should update status for current user when logged in" do
    sign_in users(:scott)
    patch :update, id: @status, status: { content: @status.content, user_id: users(:steve).id }
    assert_redirected_to status_path(assigns(:status))
    assert_equal assigns(:status).user_id, users(:scott).id
  end

  test "should not update status if nothing has changed" do
    sign_in users(:scott)
    patch :update, id: @status
    assert_redirected_to status_path(assigns(:status))
    assert_equal assigns(:status).user_id, users(:scott).id
  end

  test "should redirect status update when not logged in" do
    put :update, id: @status, status: {content: @status.content}
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should destroy status" do
    assert_difference('Status.count', -1) do
      delete :destroy, id: @status
    end

    assert_redirected_to statuses_path
  end
end
