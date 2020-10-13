require 'rails_helper'

RSpec.describe RatesController, type: :controller do
  describe '#create' do
    def do_request
      post :create, xhr: true, params: { post_id: article.id, rate: rate_params }
    end

    let!(:user) { FactoryBot.create(:user) }
    before { sign_in user }

    let!(:article) { FactoryBot.create(:post) }

    context 'with rate exists' do
      let!(:rate) { FactoryBot.create(:rate, user: user, post: article) }
      let(:rate_params) { FactoryBot.attributes_for(:rate, user: user, post: article) }

      it 'should update rate' do
        do_request
        expect(rate.reload.value).to eq(rate_params[:value])
      end
    end

    context 'with rate does not exist' do
      let(:rate_params) { FactoryBot.attributes_for(:rate, user: user, post: article) }

      it 'should create new rate' do
        expect { do_request }.to change { Rate.count }.by(1)
      end
    end
  end

end
