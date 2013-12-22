class User < ActiveRecord::Base
  validates :name, presence: true
  validates :email, presence: true
  validates :name, length: { maximum: 50 }
end
