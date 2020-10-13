require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe 'post_rate' do
    context 'without post exists' do
      let(:post) { nil }

      it { expect(helper.post_rate(post)).to eq 0 }
    end

    context 'with post exists and post have rate' do
      let!(:post) { FactoryBot.create(:post) }
      let!(:rate1) { FactoryBot.create(:rate, post: post) }
      let!(:rate2) { FactoryBot.create(:rate, post: post) }
      let(:post_rate) { (rate1.value + rate2.value) / 2 }

      it { expect(helper.post_rate(post)).to eq post_rate }
    end

    context 'with post exists but post have no rate' do
      let!(:post) { FactoryBot.create(:post) }

      it { expect(helper.post_rate(post)).to eq 0 }
    end
  end

end
