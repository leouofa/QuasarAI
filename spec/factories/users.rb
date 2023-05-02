# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string
#  locked_at              :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  has_access             :boolean          default(FALSE)
#  admin                  :boolean          default(FALSE)
#
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
