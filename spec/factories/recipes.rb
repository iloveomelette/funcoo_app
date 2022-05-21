FactoryBot.define do
  factory :recipe do
    user
    title { Faker::Lorem.word }
    content { Faker::Lorem.paragraph }
    cooking_time { 100 }
    cooking_cost { 100 }
    calorie { 100 }
  end

  trait :invalid do
    title { "a" * 101 }
  end
end
