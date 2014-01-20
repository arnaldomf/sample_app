class MicropostsController < ApplicationController
  before_action :signed_in_user
  before_action :correct_user, only: :destroy

  def create
    return_hash = Micropost.post_it!(micropost_params[:content], current_user)
    return_hash.each { |k,v| flash[k] = v unless v.nil? }
    redirect_to root_url
  end

  def destroy
    @micropost.destroy
    redirect_to root_url
  end

private
  def micropost_params
    params.require(:micropost).permit(:content)
  end
  def correct_user
    # used find_by instead of find, find raises eception if micropost not found
    @micropost = current_user.microposts.find_by(id: params[:id])
    redirect_to root_url if @micropost.nil?
  end
end
