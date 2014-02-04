class StaticPagesController < ApplicationController
  def home
    if signed_in?
      @micropost = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
      respond_to do |format|
        format.html
        format.rss do
          @user = current_user
          @microposts = @user.feed
          render "users/show"
        end
      end
    else
      respond_to do |format|
        format.html
        format.rss { render nothing: true, status: :forbidden }
      end
    end

  end

  def help
  end

  def about
  end

  def contact
  end
end
