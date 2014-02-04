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
    respond_to do |format|
      format.html { @microposts = @user.microposts.paginate(page: params[:page]) }
      format.rss  { @microposts = @user.microposts }
    end
  end

  def new
    @user = User.new
  end

  def create
    ucb = UserConfirmationBuilder.new(user_params)
    if ucb.save!
      flash[:success] = "Welcome, please click on the confirmation link sent " +
      "to your email"
      UserMailer.welcome_email(ucb.user, ucb.confirmation).deliver
      redirect_to root_path
    else
      @user = ucb.user
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
