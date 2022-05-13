class AddUrlToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :url, :text, limit: 2000
  end
end
