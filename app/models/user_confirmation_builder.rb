require 'securerandom'

class UserConfirmationBuilder
  attr_reader :user, :confirmation
  def initialize(options = {})
    @user = User.new(options)
    # 6 bytes, 12 chars ([0-9a-f])
    @code = SecureRandom.hex(6)
  end
  def save!
    result = true
    User.transaction do
      @user.save
      @confirmation = Confirmation.create(user_id: @user.id, code: @code)
    end
    result = false if @confirmation.nil? or !@confirmation.valid?
    return result
  end
end
