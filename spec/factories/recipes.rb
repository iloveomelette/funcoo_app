FactoryBot.define do
  factory :recipe do
    user { nil }
    title { "MyString" }
    content { "MyText" }
    menu_image { "MyString" }
    cooking_time { 1 }
    cooking_cost { 1 }
    calorie { 1 }
  end
end
