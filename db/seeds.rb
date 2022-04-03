# テーブルを再生成
ActiveRecord::Base.connection.execute("SET FOREIGN_KEY_CHECKS = 0")
ActiveRecord::Base.connection.execute("TRUNCATE TABLE users")
ActiveRecord::Base.connection.execute("TRUNCATE TABLE recipes")
ActiveRecord::Base.connection.execute("TRUNCATE TABLE makes")
ActiveRecord::Base.connection.execute("SET FOREIGN_KEY_CHECKS = 1")

# 開発用のユーザを作成
user1 = User.create!(name: "sato", email: "sato@example.com", password: "password", characteristic: 1)
user2 = User.create!(name: "hanada", email: "hanada@example.com", password: "password", characteristic: 1)
user3 = User.create!(name: "kawaguchi", email: "kawaguchi@example.com", password: "password", characteristic: 1)
User.create!(name: "kato", email: "kato@example.com", password: "password", characteristic: 0)
User.create!(name: "suzuki", email: "suzuki@example.com", password: "password", characteristic: 0)
User.create!(name: "tanaka", email: "tanaka@example.com", password: "password", characteristic: 0)
User.create!(name: "maeda", email: "maeda@example.com", password: "password", characteristic: 0)
User.create!(name: "kikuchi", email: "kikuchi@example.com", password: "password", characteristic: 0)

# 開発用のレシピを作成
i = 1
5.times do
  user1.recipes.create!(title: "sample_0#{i}", content: "content_0#{i}", cooking_time: 200, cooking_cost: 200, calorie: 200)
  i += 1
end
5.times do
  user2.recipes.create!(title: "sample_0#{i}", content: "content_0#{i}", cooking_time: 200, cooking_cost: 200, calorie: 200)
  i += 1
end
5.times do
  user3.recipes.create!(title: "sample_0#{i}", content: "content_0#{i}", cooking_time: 200, cooking_cost: 200, calorie: 200)
  i += 1
end

puts "初期データの挿入に成功しました！"
