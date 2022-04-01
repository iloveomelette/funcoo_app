class AddMakesCountToRecipes < ActiveRecord::Migration[6.1]
  def change
    add_column :recipes, :makes_count, :integer, default: 0
  end
end
