FactoryBot.define do
  factory :user do
    name { Faker::Internet.username(specifier: 3..12) }
    admin_level { 3 }
    password { Faker::Internet.password }
    email { Faker::Internet.email }
  end
end
