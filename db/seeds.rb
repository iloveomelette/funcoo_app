# ====== 本番環境のレベル閾値投入処理 ======
i = 2
point = 30
LevelSetting.create!(passing_level: 1, threshold: 0)
50.times do
  LevelSetting.create!(passing_level: i, threshold: point)
  i += 1
  point *= 1.2
  point = point.round
end

puts "初期データの挿入に成功しました！"

# ====== 開発環境の初期データ投入処理 ======

# テーブルを再生成
# ActiveRecord::Base.connection.execute("SET FOREIGN_KEY_CHECKS = 0")
# table_names = ["users", "recipes", "makes", "genres", "level_settings", "recommends"]
# table_names.each do |table_name|
#   ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{table_name}")
# end
# ActiveRecord::Base.connection.execute("SET FOREIGN_KEY_CHECKS = 1")

# require "faker"
# Faker::Config.locale = :ja

# # 開発用のユーザを作成
# user1 = User.create!(name: "sato", email: "sato@example.com", password: "password", characteristic: 1)
# user2 = User.create!(name: "hanada", email: "hanada@example.com", password: "password", characteristic: 1)

# 5.times do
#   User.create!(name: Faker::Name.name, email: Faker::Internet.email, password: "password", characteristic: 0)
# end

# genre_num = (0..3).to_a
# 30.times do
#   recipe_a = user1.recipes.create!(title: Faker::Food.dish, content: Faker::Food.description, cooking_time: 200, cooking_cost: 200, calorie: 200)
#   Genre.create(recipe_id: recipe_a.id, staple_food: genre_num.sample, main_dish: genre_num.sample,
#     side_dish: genre_num.sample, country_dish: genre_num.sample)

#   recipe_b = user2.recipes.create!(title: Faker::Food.dish, content: Faker::Food.description, cooking_time: 200, cooking_cost: 200, calorie: 200)
#   Genre.create(recipe_id: recipe_b.id, staple_food: genre_num.sample, main_dish: genre_num.sample,
#     side_dish: genre_num.sample, country_dish: genre_num.sample)
# end

# recipe_ids = (1..50).to_a
# recipe_ids.each do |id|
#   Make.create!(user_id: 3, recipe_id: id)
#   Make.create!(user_id: 4, recipe_id: id)
#   Make.create!(user_id: 5, recipe_id: id)
# end
