class FollowsController < ApplicationController
  before_action :authenticate_user!
  before_action :is_user_authorized?, only: :destroy
  
  def create
    @follow = current_user.follows_to.build(followed_id: params[:followed_id])
    if @follow.save
      flash[:notice] = "Followed user"
      redirect_to user_path(:followed_id)
    else
      flash[:error] = "Couldn't follow user"
      redirect_to user_path(@follow.followed_id)
    end
  end

  def destroy
    @follow = current_user.follows_to.find(params[:id])
    @follow.destroy
    flash[:notice] = "Unfollowed user"
    redirect_to user_path(@follow.followed_id)
  end

  private

  def is_user_authorized?
    follow = Follow.find(params[:id])
    if current_user.id != follow.follower_id
      redirect_to user_path(follow.follower_id)
    end
  end
end