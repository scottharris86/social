require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

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
end
