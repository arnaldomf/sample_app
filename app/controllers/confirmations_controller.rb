class ConfirmationsController < ApplicationController
  # before_action :signed_in_user
  
  def show
    # how to change paramete name, from id to code?
    confirmation = Confirmation.where(user_id: params[:user_id],
      code: params[:id]).first
    result = UserConfirmer.confirm(confirmation)
    redirect_to signin_url if result
    redirect_to root_url, notice: "Invalid confirmation" if !result 
  end
end
