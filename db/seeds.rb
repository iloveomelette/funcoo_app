# テーブルを再生成
ActiveRecord::Base.connection.execute("SET FOREIGN_KEY_CHECKS = 0")
ActiveRecord::Base.connection.execute("TRUNCATE TABLE users")
ActiveRecord::Base.connection.execute("TRUNCATE TABLE recipes")
ActiveRecord::Base.connection.execute("TRUNCATE TABLE makes")
ActiveRecord::Base.connection.execute("TRUNCATE TABLE genres")
ActiveRecord::Base.connection.execute("SET FOREIGN_KEY_CHECKS = 1")

require "faker"
Faker::Config.locale = :ja

# 開発用のユーザを作成
user1 = User.create!(name: "sato", email: "sato@example.com", password: "password", characteristic: 1)
user2 = User.create!(name: "hanada", email: "hanada@example.com", password: "password", characteristic: 1)

5.times do
  User.create!(name: Faker::Name.name, email: Faker::Internet.email, password: "password", characteristic: 0)
end

genre_num = (0..3).to_a
30.times do
  recipe_a = user1.recipes.create!(title: Faker::Food.dish, content: Faker::Food.description, cooking_time: 200, cooking_cost: 200, calorie: 200)
  Genre.create(recipe_id: recipe_a.id, staple_food: genre_num.sample, main_dish: genre_num.sample, side_dish: genre_num.sample, country_dish: genre_num.sample)

  recipe_b = user2.recipes.create!(title: Faker::Food.dish, content: Faker::Food.description, cooking_time: 200, cooking_cost: 200, calorie: 200)
  Genre.create(recipe_id: recipe_b.id, staple_food: genre_num.sample, main_dish: genre_num.sample, side_dish: genre_num.sample, country_dish: genre_num.sample)
end

recipe_ids = (1..50).to_a
recipe_ids.each do |id|
  Make.create!(user_id: 3, recipe_id: id)
  Make.create!(user_id: 4, recipe_id: id)
  Make.create!(user_id: 5, recipe_id: id)
end

puts "初期データの挿入に成功しました！"
