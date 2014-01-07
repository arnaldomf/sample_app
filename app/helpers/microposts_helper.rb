module MicropostsHelper

  def wrap(micropost)
    if micropost.in_reply_to?
      content = micropost.content.split
      at_str = content[0]
      content[0] = link_to at_str, user_path(micropost.in_reply_to)
      micropost.content = content.join(' ')
      puts micropost.content
    end
    #sanitize(raw(micropost.content.split.map{|s| wrap_long_string(s)}.join(' ')))
    sanitize(raw(micropost.content))
  end

private
  def wrap_long_string(text, max_width = 30)
    zero_width_space = "&#8203;"
    regex = /.{1,#{max_width}}/
    (text.length < max_width) ? text :
                                text.scan(regex).join(zero_width_space)
  end
end
