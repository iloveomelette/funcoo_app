class CreateMakes < ActiveRecord::Migration[6.1]
  def change
    create_table :makes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :recipe, null: false, foreign_key: true

      t.timestamps
    end
    add_index :makes, [:user_id, :recipe_id], unique: true
  end
end
