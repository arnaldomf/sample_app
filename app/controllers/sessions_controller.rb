class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if sign_in user
        redirect_back_or user
      else
        flash[:notice] = "Please, confirm your email"
        redirect_to root_url
      end
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end
  def destroy
    sign_out
    redirect_to root_url
  end
end
