require 'rails_helper'

RSpec.describe Like, type: :model do
  describe 'factory' do
    context 'true' do
      let(:like) { FactoryBot.build(:like) }
      it { expect(like).to be_valid }
    end

    context 'false' do
      let(:like) { FactoryBot.build(:like, user: nil) }
      it { expect(like).not_to be_valid }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:post) }
  end

end
