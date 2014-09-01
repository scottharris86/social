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
    UserFriendship.create user_id: users(:scott).id, friend_id: users(:steve).id
    assert users(:scott).pending_friends.include?(users(:steve))
  end

  context "a new instance" do
    setup do
      @user_friendship = UserFriendship.new user: users(:scott), friend: users(:steve)
    end

    should "have a pending state" do
      assert_equal "pending", @user_friendship.state
    end
  end

  context "#send_request_email" do
    setup do
      @user_friendship = UserFriendship.create user: users(:scott), friend: users(:steve)
    end

    should "send an email" do
      assert_difference 'ActionMailer::Base.deliveries.size', 1 do
        @user_friendship.send_request_email
      end
    end
  end

  context "#mutual_friendship" do 
    setup do
      UserFriendship.request users(:scott), users(:steve)
      @friendship1 = users(:scott).user_friendships.where(friend_id: users(:steve).id).first
      @friendship2 = users(:steve).user_friendships.where(friend_id: users(:scott).id).first
    end
    should "correctly find the mutual friendship" do
      assert_equal @friendship2, @friendship1.mutual_friendship
    end
  end

  context "#accept_mutual_friendship!" do
    setup do
      UserFriendship.request users(:scott), users(:steve)
    end
    should "accept the mutual friendship" do
      friendship1 = users(:scott).user_friendships.where(friend_id: users(:steve).id).first
      friendship2 = users(:steve).user_friendships.where(friend_id: users(:scott).id).first
      friendship1.accept_mutual_friendship!
      friendship2.reload
      assert_equal 'accepted', friendship2.state

    end
  end

  context "#accept!" do
    setup do
      @user_friendship = UserFriendship.request users(:scott), users(:steve)
    end

    should "set the state to accepted" do
      @user_friendship.accept!
      assert_equal "accepted", @user_friendship.state
    end
    should "send acceptance email" do
      assert_difference 'ActionMailer::Base.deliveries.size', 1 do
        @user_friendship.accept!
      end
    end

    should "include the firend in the list of friends" do
      @user_friendship.accept!
      users(:scott).friends.reload
      assert users(:scott).friends.include?(users(:steve))
    end

    should "accept the mutual friendship" do
      @user_friendship.accept!
      assert_equal 'accepted', @user_friendship.mutual_friendship.state
    end

  end

  context ".request" do
    should "create two user friendships" do
      assert_difference 'UserFriendship.count', 2 do
        UserFriendship.request(users(:scott), users(:steve))
      end
    end

    should "send friend request email" do
      assert_difference 'ActionMailer::Base.deliveries.count', 1 do
        UserFriendship.request(users(:scott), users(:steve))
      end
    end
  end

  context "#delete_mutual_friendship!" do
    setup do
      UserFriendship.request users(:scott), users(:steve)
      @friendship1 = users(:scott).user_friendships.where(friend_id: users(:steve).id).first
      @friendship2 = users(:steve).user_friendships.where(friend_id: users(:scott).id).first
    end
    should "delete the mutual friendship" do
      assert_equal @friendship2, @friendship1.mutual_friendship
      @friendship1.delete_mutual_friendship!
      assert !UserFriendship.exists?(@friendship2.id)
    end
  end

  context "on destroy" do
    setup do
      UserFriendship.request users(:scott), users(:steve)
      @friendship1 = users(:scott).user_friendships.where(friend_id: users(:steve).id).first
      @friendship2 = users(:steve).user_friendships.where(friend_id: users(:scott).id).first
    end
    should "delete the mutual friendship" do
      @friendship1.destroy
      assert !UserFriendship.exists?(@friendship2.id)
    end
  end

  context "#block!" do
    setup do
      @user_friendship = UserFriendship.request users(:scott), users(:steve)
    end

    should "set the state to blocked" do
      @user_friendship.block!
      assert_equal "blocked", @user_friendship.state
      assert_equal "blocked", @user_friendship.mutual_friendship.state
    end

    should "not allow user friendship once blocked" do
      @user_friendship.block!
      uf = UserFriendship.request users(:scott), users(:steve)
      assert !uf.save
    end

  end

end

