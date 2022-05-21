require "faker"

FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.unique.email }
    url { "https://www.google.com/" }
    introduction { Faker::Quote.famous_last_words }
    password { "password" }
  end
end
