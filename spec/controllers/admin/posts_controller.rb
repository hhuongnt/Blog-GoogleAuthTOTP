require 'rails_helper'

RSpec.describe Admin::PostsController, type: :controller do
  describe '#index' do
    def do_request
      get :index
    end

    let(:admin) { FactoryBot.create(:user, role: 'admin') }
    let!(:post1) { FactoryBot.create(:post, status: 'Approved') }
    let!(:post2) { FactoryBot.create(:post, status: 'Declined') }
    let!(:post3) { FactoryBot.create(:post) }

    before { sign_in admin }

    it 'should render :index' do
      do_request
      expect(assigns(:new_posts)).to eq([post3])
      expect(assigns(:approved_posts)).to eq([post1])
      expect(assigns(:declined_posts)).to eq([post2])
      expect(response).to render_template :index
    end
  end

  describe '#show' do
    def do_request
      get :show, params: { id: post.id }
    end

    let(:admin) { FactoryBot.create(:user, role: 'admin') }
    let!(:post) { FactoryBot.create(:post) }

    before { sign_in admin }

    it 'should render :show' do
      do_request
      expect(response).to redirect_to post_path(post)
    end
  end

  describe '#destroy' do
    def do_request
      delete :destroy, params: { id: post.id }
    end

    let(:admin) { FactoryBot.create(:user, role: 'admin') }
    let!(:post) { FactoryBot.create(:post) }

    before { sign_in admin }

    it 'should delete post' do
      expect { do_request }.to change { Post.count }.by(-1)
      expect(flash[:notice]).to eq 'Post was successfully destroyed.'
      expect(response).to redirect_to admin_posts_path
    end
  end
end
