class UserConfirmer

  def self.get_user_from_confirmation(confirmation)
    User.find_by(id: confirmation.user_id) if !confirmation.nil?
  end

  def self.confirm(confirmation)
    user = self.get_user_from_confirmation(confirmation)
    return false if user.nil?
    result = true
    Confirmation.transaction do
      begin
        user.confirm!
        confirmation.destroy!
      rescue
        result = false
      end
    end
    result
  end
end
