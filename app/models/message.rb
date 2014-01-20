class Message < ActiveRecord::Base
  # Constants
  STARTER_PATTERN = /\Ad@(\w+)/

  # associations
  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"

  # validations
  validates :content, presence: true, length: {maximum: 140}
  validates :sender_id, presence: true
  validates :receiver_id, presence: true
  validate :sender_cannot_send_message_to_himself
  validate :verify_start_string
  # callbacks
  
  def self.build_it!(content, sender, receiver_screen_name)
    receiver_id = User.where(screen_name: receiver_screen_name).pluck(:id)
    receiver_id[0] = nil if receiver_id.empty?
    sender.messages.build(content: content, receiver_id: receiver_id[0])
  end

  def self.messages_from_to_user(user)
    messages_from_ids = "SELECT messages.id from messages
                        WHERE messages.sender_id = :user_id"
    messages_to_ids   = "SELECT messages.id from messages
                        WHERE messages.receiver_id = :user_id"
    where("id IN (#{messages_from_ids}) OR id IN (#{messages_to_ids})",
      user_id: user).order(created_at: :desc)
  end

  private
    def sender_cannot_send_message_to_himself
      if sender_id == receiver_id
        errors.add(:receiver_id, "can't be the same as sender")
      end
    end

    def verify_start_string
      if content.match(STARTER_PATTERN).nil?
        errors.add(:content, "content doesn't starts with d@")
      end
    end
  
end
