class AddStateToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :state, :integer, default: 0
    add_index  :users, :state
    User.reset_column_information
    User.all.each do |user|
      user.update_attribute :state, 1
    end
  end
  def self.down
    remove_column :users, :state
  end
end
