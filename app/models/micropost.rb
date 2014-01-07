class Micropost < ActiveRecord::Base
  belongs_to :user
  before_save :set_in_reply_to
  default_scope -> { order('created_at DESC')}
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}

  REPLY_TO_PATTERN = /\A@(\w+)/

  def in_reply_to?
    true if in_reply_to
  end

  def set_in_reply_to
    match = content.match(REPLY_TO_PATTERN)
    at_string = match[1] if match
    other_user = User.find_by(screen_name: at_string) if at_string
    self.in_reply_to = other_user.id if other_user
  end

  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id
      OR in_reply_to = :user_id",
      user_id: user)
  end
end
