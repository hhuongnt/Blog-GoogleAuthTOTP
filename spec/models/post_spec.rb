require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'factory' do
    context 'true' do
      let(:post) { FactoryBot.build(:post) }

      it { expect(post).to be_valid }
    end

    context 'false' do
      let(:post) { FactoryBot.build(:post, title: nil) }

      it { expect(post).not_to be_valid }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:category) }
    it { is_expected.to have_many(:likes).dependent(:destroy) }
    it { is_expected.to have_many(:comments).dependent(:destroy) }
    it { is_expected.to have_many(:rates).dependent(:destroy) }
    # it { is_expected.to have_many(:user_rated).through(:rate) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:content) }
  end

  describe 'scope approved' do
    context 'approved posts exists' do
      let(:approved) { FactoryBot.create(:post, status: 'Approved') }
      let(:declined) { FactoryBot.create(:post, status: 'Declined') }
      let(:new) { FactoryBot.create(:post) }

      it { expect(described_class.approved).to include(approved) }
    end

    context 'no approved posts exists' do
      let(:new) { FactoryBot.create(:post) }
      let(:declined) { FactoryBot.create(:post, status: 'Declined') }

      it { expect(described_class.approved).not_to include(new, declined) }
    end
  end

  describe 'search' do
    context 'search category' do
      let(:search) { 'puPPies' }
      let!(:category) { FactoryBot.create(:category, name: 'puppies') }
      let!(:post) { FactoryBot.create(:post, category: category, status: 'Approved') }
      let!(:post1) { FactoryBot.create(:post, title: 'puppies', status: 'Approved') }

      it { expect(described_class.search(search)).to include(post) }
    end

    context 'search title when no category match' do
      let(:search) { 'puppies' }
      let!(:post) { FactoryBot.create(:post, status: 'Approved') }
      let!(:post1) { FactoryBot.create(:post, title: 'puppies are super cute', status: 'Approved') }

      it { expect(described_class.search(search)).to include(post1) }
    end
  end

  describe 'rating_point' do
    context 'return value if existed' do
      let(:user) { FactoryBot.create(:user) }
      let(:post) { FactoryBot.create(:post) }
      let!(:rate) { FactoryBot.create(:rate, user: user, post: post) }

      it do
        expect(post.rating_point(user)).to eq rate.value
      end
    end

    context 'return nil if not exists' do
      let(:user) { FactoryBot.create(:user) }
      let(:post) { FactoryBot.create(:post) }

      it { expect(post.rating_point(user)).to be_nil }
    end
  end

end
