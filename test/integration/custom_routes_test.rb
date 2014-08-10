require 'test_helper'

class CustomRoutesTest < ActionDispatch::IntegrationTest
  test "the /login route opens the login page" do 
    get 'login'
    assert_response :success
  end

  test "the /logout route opens the logout page" do 
    get 'logout'
    assert_response :redirect
    assert_redirected_to '/'
  end

  test "the /register route opens the register page" do 
    get 'register'
    assert_response :success
  end

  test "can get a persons profile page" do
    get '/2big2fail'
    assert_response :success
  end
end
