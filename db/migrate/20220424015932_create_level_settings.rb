class CreateLevelSettings < ActiveRecord::Migration[6.1]
  def change
    create_table :level_settings do |t|
      t.integer :passing_level
      t.integer :threshold

      t.timestamps
    end
  end
end
