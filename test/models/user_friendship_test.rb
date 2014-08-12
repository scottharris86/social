require 'test_helper'

class UserFriendshipTest < ActiveSupport::TestCase
  should belong_to(:user)
  should belong_to(:friend)

  test "that creating a friendship works without raising exeption" do
    assert_nothing_raised do
      UserFriendship.create user: users(:scott), friend: users(:chad)
    end 
  end

  test "that creating a friendship based on user_id and friend_id works" do
    UserFriendship.create user_id: users(:scott).id, friend_id: users(:chad).id
    assert users(:scott).friends.include?(users(:chad))
  end

end

