class ChangeRelationshipUniqueIndex < ActiveRecord::Migration
  def change
    remove_index :relationships, [:follower_id, :follower_id]
    add_index :relationships, [:follower_id, :followed_id], unique: true
  end
end
