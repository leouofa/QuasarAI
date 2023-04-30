FactoryBot.define do
  factory :user, aliases: [:member] do
    email { rand(2..1000).to_s + Faker::Internet.unique.email }
    password { Faker::Internet.password }

    trait :admin do
      after(:create) { |user, _evaluator| user.make_admin }
    end

    trait :with_access do
      after(:create) { |user, _evaluator| user.give_access }
    end
  end
end
