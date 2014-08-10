require 'test_helper'

class ProfilesControllerTest < ActionController::TestCase
  test "should get show" do
    get :show, id: users(:scott).profile_name
    assert_response :success
    assert_template 'profiles/show'
  end

  test "should render a 404 status page on profile not found" do
    get :show, id: 'doesnt exist'
    assert_response :not_found
  end

  test "that variable are assigned on successful show page" do
    get :show, id: users(:scott).profile_name
    assert assigns(:user)
    assert_not_empty assigns(:statuses)
  end

  test "only the users statuses show" do
    get :show, id: users(:scott).profile_name
    assigns(:statuses).each do |status|
      assert_equal users(:scott), status.user 
    end
  end

end
