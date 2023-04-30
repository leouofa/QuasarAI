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
