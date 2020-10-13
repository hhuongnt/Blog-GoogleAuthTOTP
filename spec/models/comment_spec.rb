require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'factory' do
    context 'true' do
      let(:comment) { FactoryBot.build(:comment) }
      it { expect(comment).to be_valid }
    end

    context 'false' do
      let(:comment) { FactoryBot.build(:comment, content: nil) }
      it { expect(comment).not_to be_valid }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:post) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:content) }
  end

end
