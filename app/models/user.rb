# source: forces rails to look for followed_id in relationship instead of
# followed_users_id
class User < ActiveRecord::Base
  has_one  :confirmation, dependent: :destroy
  has_many :messages, foreign_key: "sender_id"
  has_many :reverse_messages, foreign_key: "receiver_id", class_name: "Message"
  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name: "Relationship",
                                   dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :followers, through: :reverse_relationships, source: :follower
  before_create :create_remember_token
  before_save { self.email = email.downcase }
  before_save { self.screen_name = screen_name.downcase }

  validates :name, presence: true,length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
            uniqueness: {case_sensitive: false}
  has_secure_password
  # validates :password, length: {minimum: 6}
  validate :password_length_validation
  validates :screen_name, presence: true, format: { with: /\A\w+\z/i},
            uniqueness: {case_sensitive: true}
# must have a column named password_digest

# state machine for user's confirmation
state_machine initial: :pending do
  state :pending, value: 0
  state :confirmed, value: 1
  state :deleted, value: 2

  event :confirm do
    transition :pending => :confirmed
  end
end

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def feed
    # Micropost.where('user_id = ?', id)
    Micropost.from_users_followed_by(self)
  end

  def message_feed
    Message.messages_from_to_user(self)
  end

  def following?(other_user)
    relationships.find_by(followed_id: other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by(followed_id: other_user.id).destroy!
  end

  private
    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
    def password_length_validation
      if self.new_record?
        if self.password.nil? or self.password.length < 6
          errors.add(:password,"is too short (minimum is 6 characters)") 
        end
      end
    end

end
