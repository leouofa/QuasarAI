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
require 'rails_helper'

describe User, type: :model do
  it 'must have a user factory' do
    user = FactoryBot.create(:user)
    expect(user).to be_valid
  end

  it 'must have an admin factory' do
    admin = FactoryBot.create(:user, :admin)
    expect(admin.admin).to be true
  end

  it 'must have a with_access factory' do
    user_with_access = FactoryBot.create(:user, :with_access)
    expect(user_with_access.has_access).to be true
  end

  it 'default users do not have admin privileges' do
    user = FactoryBot.create(:user)
    expect(user.admin).to be false
  end

  it 'you can make a user admin' do
    user = FactoryBot.create(:user)
    user.make_admin
    expect(user.admin).to be true
  end

  it 'you can unmake the admin' do
    admin = FactoryBot.create(:user, :admin)
    admin.unmake_admin
    expect(admin.admin).to be false
  end

  it 'you can give access' do
    user = FactoryBot.create(:user)
    user.give_access
    expect(user.has_access).to be true
  end

  it 'you can remove access' do
    admin = FactoryBot.create(:user, :with_access)
    admin.remove_access
    expect(admin.has_access).to be false
  end
end
