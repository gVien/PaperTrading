class RelationshipsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  def create
    # followed_id is the id of the user being followed, as shown in hidden field (users/_followed.html.erb)
    user = User.find(params[:followed_id])
    current_user.follow(user)
    redirect_to user_path(user) # or simply `redirected_to user`
  end

  def destroy
    # find the relationship between the current_user and the one being followed (shown in params[:id]), and obtain user info
    # i.e. find the user the current_user is following
    user = Relationship.find(params[:id]).followed  #followed is the user that the current_user (follower) is following
    current_user.unfollow(user)
    redirect_to user_path(user)
  end
end
