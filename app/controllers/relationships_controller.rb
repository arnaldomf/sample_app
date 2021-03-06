class RelationshipsController < ApplicationController
  before_action :signed_in_user

  def create
    @user = User.find(params[:relationship][:followed_id])
    current_user.follow!(@user)
    UserMailer.followed_email(@user,current_user).deliver
    respond_to do |format|
      format.html { redirect_to @user }
      # in case of ajax, rails calls a javascript called <action>.js.erb
      format.js
    end
  end
  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
end
