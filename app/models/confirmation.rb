class Confirmation < ActiveRecord::Base
  validates :code, presence: true, length: {minimum: 6}
  validates :user_id, presence: true, uniqueness: true

  def to_param
    code
  end
end
