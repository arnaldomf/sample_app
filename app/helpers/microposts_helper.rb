module MicropostsHelper

  def micropost_account_link(account, in_reply_to)
    if in_reply_to
      link_to account, user_path(in_reply_to)
    else
      user = User.find_by(screen_name: account[1 .. -1])
      if user
        link_to account, user_path(user)
      else
        wrap_long_string account
      end
    end
  end

  def wrap(micropost)
    sanitize(raw(micropost.content.split.map do |s|
      if s.start_with?('@')
        micropost_account_link(s, micropost.in_reply_to)
      else
        wrap_long_string(s)
      end
    end.join(' ')))
  end

private
  def wrap_long_string(text, max_width = 30)
    zero_width_space = "&#8203;"
    regex = /.{1,#{max_width}}/
    (text.length < max_width) ? text :
                                text.scan(regex).join(zero_width_space)
  end
end
