class ChangeUserInRoomsToNullable < ActiveRecord::Migration[7.0]
  def change
    change_column :rooms, :user_id, :integer, null: true
  end
end
