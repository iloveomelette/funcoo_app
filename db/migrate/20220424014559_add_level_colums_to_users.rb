class AddLevelColumsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :level, :integer, null: false, default: 1
    add_column :users, :experience_point, :integer, null: false, default: 0
    add_column :users, :rest_point, :integer, null: false, default: 30
  end
end
