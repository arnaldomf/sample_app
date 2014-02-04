xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Microposts"
    xml.description "#{@user.screen_name}'s post"
    xml.link user_url(@user, :rss)
    @microposts.each do |micropost|
      xml.item do
        xml.title "#{micropost.user.name} - #{micropost.created_at.to_s(:rfc822)}"
        xml.description micropost.content
        xml.pubDate micropost.created_at.to_s(:rfc822)
      end
    end

  end
end
