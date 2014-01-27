class AddIndexesToConfirmations < ActiveRecord::Migration
  def change
    add_index :confirmations, [:user_id, :code]
    add_index :confirmations, :user_id, unique: true
  end
end
