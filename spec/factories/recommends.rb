FactoryBot.define do
  factory :recommend do
    user { nil }
    recommend_recipe { 1 }
    avg_staple { 1.5 }
    avg_main { 1.5 }
    avg_side { 1.5 }
    avg_country { 1.5 }
  end
end
