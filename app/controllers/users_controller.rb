class UsersController < ApplicationController
  before_action :signed_in_user, only: [:edit, :update, :index,
                                        :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def destroy
    #User.find(params[:id]).destroy
    @user.destroy
    flash[:success] = "User deleted."
    redirect_to users_url
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      UserMailer.welcome_email(@user).deliver
      redirect_to @user
    else
#      flash[:error] = "Oops... try again!"
      render 'new'
    end
  end

  def edit
#    @user = User.find(params[:id])
  end

  def update
#   @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation, :screen_name)
    end
    def correct_user
#      redirect_to root_url if current_user.id != params[:id]
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
    def admin_user
      redirect_to(root_url) unless current_user.admin?
      @user = User.find(params[:id])
      if current_user?(@user)
        flash[:error] = "thou cannot kill thyself!"
        redirect_to users_url
      end
    end

end
