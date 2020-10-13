require 'rails_helper'

RSpec.describe LikesController, type: :controller do
  describe '#create' do
    def do_request
      post :create, xhr: true, params: { post_id: article.id }
    end

    let!(:user) { FactoryBot.create(:user) }
    let!(:article) { FactoryBot.create(:post) }

    before { sign_in user }

    it 'should create new like' do
      expect { do_request }.to change { Like.count }.by(1)
    end
  end

  describe '#destroy' do
    def do_request
      delete :destroy, xhr: true, params: { id: like.id, post_id: post.id }
    end

    let!(:user) { FactoryBot.create(:user) }

    before { sign_in user }

    let!(:post) { FactoryBot.create(:post) }
    let!(:like) { FactoryBot.create(:like, user: user, post: post) }

    it 'should delete like' do
      expect { do_request }.to change { Like.count }.by(-1)
    end
  end

end
