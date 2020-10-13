require 'rails_helper'

RSpec.describe Rate, type: :model do
  describe 'factory' do
    context 'true' do
      let(:rate) { FactoryBot.build(:rate) }
      it { expect(rate).to be_valid }
    end

    context 'false' do
      let(:rate) { FactoryBot.build(:rate, value: nil) }
      it { expect(rate).not_to be_valid }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:post) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:value) }
  end

end
