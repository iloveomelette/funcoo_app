FactoryBot.define do
  factory :genre do
    recipe
    staple_food { "rice" }
    main_dish { "meat" }
    side_dish { "vegetables" }
    country_dish { "japanese" }
  end
end
