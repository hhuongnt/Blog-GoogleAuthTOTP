require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'factory' do
    context 'true' do
      let!(:user) { FactoryBot.build(:user) }

      it { expect(user).to be_valid }
    end

    context 'false' do
      let!(:user) { FactoryBot.build(:user, first_name: nil) }

      it { expect(user).not_to be_valid }
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:posts).dependent(:destroy) }
    it { is_expected.to have_many(:likes).dependent(:destroy) }
    it { is_expected.to have_many(:comments).dependent(:destroy) }
    it { is_expected.to have_many(:categories).dependent(:destroy) }
    it { is_expected.to have_many(:rates).dependent(:destroy) }
    # it { is_expected.to have_many(:rate_posts).through(:rates) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
  end

  describe 'find_for_facebook_oauth' do
    context 'user existed' do
      let!(:user) { FactoryBot.create(:user, provider: 'facebook', uid: '12345', email: 'test@example.com') }
      let(:auth) do
        OmniAuth::AuthHash.new({
                                 provider: 'facebook',
                                 uid: '123545',
                                 info: {
                                   email: 'test@example.com'
                                 }
                               })
      end

      it { expect(described_class.find_for_facebook_oauth(auth)).to eq user }
    end

    context 'new user' do
      let(:auth) do
        OmniAuth::AuthHash.new({
                                 provider: 'facebook',
                                 uid: '1235456',
                                 info: {
                                   email: 'test@example.com',
                                   image: ''
                                 },
                                 extra: {
                                   raw_info: {
                                     name: 'John Smith'
                                   }
                                 }
                               })
      end

      it { expect(described_class.find_for_facebook_oauth(auth).save).to be_truthy }
    end
  end

  describe 'admin' do
    context 'true' do
      let(:admin) { FactoryBot.build(:user, role: 'admin') }

      it { expect(admin.admin?).to eq true }
    end

    context 'false' do
      let(:user) { FactoryBot.build(:user) }

      it { expect(user.admin?).to eq false }
    end
  end

end
