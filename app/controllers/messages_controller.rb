class MessagesController < ApplicationController
  before_action :signed_in_user
  
  def index
    @messages = current_user.message_feed
  end
end
