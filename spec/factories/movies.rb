FactoryBot.define do
  factory :movie do
    title { Faker::Movie.title }
    description { Faker::Lorem.paragraph(sentence_count: 3) }
    image { Faker::Internet.url }
  end
end
