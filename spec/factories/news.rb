FactoryBot.define do
  factory :news do
    published_on { "2021-04-29" }
    title { "MyText" }
    body { "MyText" }
    flag { false }
  end
end
