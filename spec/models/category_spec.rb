require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'factory' do
    context 'true' do
      let(:category) { FactoryBot.build(:category) }
      it { expect(category).to be_valid }
    end

    context 'false' do
      let(:category) { FactoryBot.build(:category, name: nil) }
      it { expect(category).not_to be_valid }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:posts).dependent(:destroy) }
  end

  describe 'validations' do
    subject { FactoryBot.create(:category) }
    it { is_expected.to validate_uniqueness_of(:name) }
    it { is_expected.to validate_presence_of(:description) }
  end

end
