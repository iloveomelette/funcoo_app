class CreateRecommends < ActiveRecord::Migration[6.1]
  def change
    create_table :recommends do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :recommend_recipe, null: false
      t.float :avg_staple, null: false, default: 0
      t.float :avg_main, null: false, default: 0
      t.float :avg_side, null: false, default: 0
      t.float :avg_country, null: false, default: 0

      t.timestamps
    end
  end
end
