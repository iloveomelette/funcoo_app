class AddColumnsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :characteristic, :integer, null: false, default: 0
    add_column :users, :name, :string, null: false
    add_column :users, :introduction, :text
    add_column :users, :profile_image, :string

    add_index :users, :name
  end
end
