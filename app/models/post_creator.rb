class PostCreator

  attr_reader :error_message, :success_message, :post

  def create(content, current_user)
    match = content.match(Message::STARTER_PATTERN)
    @post = if match
              @success_message = "Direct-Message sent!"
              # build_message_from_micropost(match,current_user)
              Message.build_it!(content, current_user, match[1])
            else
              @success_message = "Micropost created!"
              current_user.microposts.build(content: content)
            end
    @post.save
    errors = ["errors"].concat(@post.errors.to_a)
    @error_message = errors
    @post
  end

  # private
  #   def build_message_from_micropost(match, current_user)
  #     content = match.string
  #     receiver_id = User.where(screen_name: match[1]).pluck(:id)
  #     if receiver_id.empty?
        
  #       receiver_id[0] = nil 
  #     end
  #     current_user.messages.build(content: content, receiver_id: receiver_id[0])
  #   end
end
