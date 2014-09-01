require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  should have_many(:user_friendships)
  should have_many(:friends)
  should have_many(:pending_user_friendships)
  should have_many(:pending_friends)
  should have_many(:requested_user_friendships)
  should have_many(:requested_friends)
  should have_many(:blocked_user_friendships)
  should have_many(:blocked_friends)

  test "a user should enter a first name" do
    user = User.new
    assert !user.save
    assert !user.errors[:first_name].empty?
  end

  test "a user should enter a last name" do
    user = User.new
    assert !user.save
    assert !user.errors[:last_name].empty?
  end

  test "a user should enter a profile name" do
    user = User.new
    assert !user.save
    assert !user.errors[:profile_name].empty?
  end

  test "a user should have a unique profile name" do
    user = User.new
    users(:scott)
    user.profile_name = users(:scott).profile_name
    
    assert !user.save
    assert !user.errors[:profile_name].empty?
  end

  test "a user should have a profile name without spaces" do
    user = User.new(first_name: 'scott', last_name: 'harris', email: 'scottharris@outlook.com')
    user.password = user.password_confirmation = 'pass1234'
    user.profile_name = "My Profile with spaces"
    
    assert !user.save
    assert !user.errors[:profile_name].empty?
    assert user.errors[:profile_name].include?("Must be formatted correctly.")
  end
  
  test "user can have a corectly formatted profile name" do
    user = User.new(first_name: 'scott', last_name: 'harris', email: 'scottharris@outlook.com')
    user.password = user.password_confirmation = 'pass1234'
    user.profile_name = 'sharris'
    assert user.valid?
  end

  test "that no error is raised when trying to get to a users friends list" do
    assert_nothing_raised do
      users(:scott).friends
    end
  end

  test "that creating a friendship works" do
    users(:scott).pending_friends << users(:steve)
    users(:scott).pending_friends.reload
    assert users(:scott).pending_friends.include?(users(:steve))
  end

  test "that calling to param on a user shows the profile name" do
    assert_equal "2big2fail", users(:scott).to_param
  end

  context "#has_blocked?" do
    should "return true if a user has blocked another user" do
      assert users(:scott).has_blocked?(users(:blocked_friend))
    end
    should "return false if a user has not blocked another user" do
      assert !users(:scott).has_blocked?(users(:steve))
    end
  end

end
