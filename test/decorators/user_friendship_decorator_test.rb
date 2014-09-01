require 'test_helper'

class UserFriendshipDecoratorTest < Draper::TestCase
  context "#submessage" do
    setup do
      @friend = create(:user, first_name: 'Steve')
    end
    context "with a pending user friendship" do
      setup do
        @user_friendhsip = create(:pending_user_friendship, friend: @friend)
        @decorator = UserFriendshipDecorator.decorate(@user_friendhsip)
      end
      should "return the correct message" do
        assert_equal "Friend Request Pending.", @decorator.sub_message
      end
    end

    context "with an accepted user friendship" do
      setup do
        @user_friendhsip = create(:accepted_user_friendship, friend: @friend)
        @decorator = UserFriendshipDecorator.decorate(@user_friendhsip)
      end
      should "return return the correct message" do
        assert_equal "You are friends with Steve", @decorator.sub_message
      end
    end
  end
  context "#friendship_state" do
    context "with a pending user friendship" do
      setup do
        @user_friendhsip = create(:pending_user_friendship)
        @decorator = UserFriendshipDecorator.decorate(@user_friendhsip)
      end
      should "return Pending" do
        assert_equal "Pending", @decorator.friendship_state
      end
    end

    context "with an accepted user friendship" do
      setup do
        @user_friendhsip = create(:accepted_user_friendship)
        @decorator = UserFriendshipDecorator.decorate(@user_friendhsip)
      end
      should "return Accepted" do
        assert_equal "Accepted", @decorator.friendship_state
      end
    end

    context "with an requestd user friendship" do
      setup do
        @user_friendhsip = create(:requested_user_friendship)
        @decorator = UserFriendshipDecorator.decorate(@user_friendhsip)
      end
      should "return Requested" do
        assert_equal "Requested", @decorator.friendship_state
      end
    end
  end
end
