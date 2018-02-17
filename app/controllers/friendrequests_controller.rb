class FriendrequestsController < ApplicationController

    def toggle_follow_request
        followee_id = params[:followee_id]
        @user = User.find(followee_id)
        @is_sent = false
        if current_user.can_follow followee_id
            Friendrequest.create(:receiver_id => followee_id,:sender_id => current_user.id,:mode => @current_mode)
            @is_sent = true
        elsif current_user.can_delete_request followee_id
            puts "can_delete_request"
            Friendrequest.where(:receiver_id => followee_id, :sender_id => current_user.id,:mode => @current_mode).first.destroy
            @is_sent = false
        elsif current_user.can_un_follow followee_id
            FollowMapping.where(:followee_id => followee_id, :follower_id => current_user.id,:mode => @current_mode).first.destroy
        end

        respond_to do |format|
            format.js { }
        end

    end

    def accept_request
        follower_id = params[:follower_id]
        @req_id = params[:req_id]
        FollowMapping.create(:followee_id => current_user.id, :follower_id => follower_id,:mode => @current_mode)
        Friendrequest.where(:receiver_id => current_user.id, :sender_id => follower_id,:mode => @current_mode).first.destroy
        puts current_user.followers_count
        current_user.followers_count += 1
        current_user.save

        respond_to do |format|
            format.js
        end
    end

    def reject_request
        follower_id = params[:follower_id]
        @req_id = params[:req_id]
        Friendrequest.where(:receiver_id => current_user.id, :sender_id => follower_id,:mode => @current_mode).first.destroy
        respond_to do |format|
            format.js
        end
    end

end
