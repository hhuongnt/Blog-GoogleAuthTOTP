require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  describe '#index' do
    def do_request
      get :index, params: { search: search_params }
    end

    let!(:post1) { FactoryBot.create(:post, title: 'Test Post1', status: 'Approved') }
    let!(:post2) { FactoryBot.create(:post, title: 'Test Post2', status: 'Approved') }

    context 'with no search' do
      let(:search_params) { nil }

      it 'should render all posts list' do
        do_request
        expect(assigns(:posts).size).to eq 2
        expect(response).to render_template :index
      end
    end

    context 'with search exists' do
      let(:search_params) { 'Test Post2' }

      it 'should render list contain Test Post2' do
        do_request
        expect(assigns(:posts)).to eq([post2])
      end
    end
  end

  describe '#new' do
    def do_request
      get :new
    end

    let!(:user) { FactoryBot.create(:user) }
    before { sign_in user }

    it 'should render :new' do
      do_request
      expect(response).to render_template :new
    end
  end

  describe '#create' do
    def do_request
      post :create, params: post_params
    end

    let!(:user) { FactoryBot.create(:user) }
    before { sign_in user }

    let(:category) { FactoryBot.create(:category) }
    context 'with valid params' do
      let(:post_params) do
        {
          post: FactoryBot.attributes_for(:post).merge(category_id: category.id)
        }
      end

      it 'should create new post' do
        expect { do_request }.to change { Post.count }.by(1)
        expect(flash[:notice]).to eq 'Post was successfully created.'
        expect(response).to redirect_to post_path(assigns[:post])
      end
    end

    context 'with invalid params' do
      let(:post_params) do
        {
          post: FactoryBot.attributes_for(:post, title: nil)
        }
      end

      it 'should not create post and then render :new' do
        expect { do_request }.to_not change { Post.count }
        expect(flash[:alert]).to eq 'Please fill in all fields.'
        expect(response).to render_template :new
      end
    end
  end

  describe '#edit' do
    def do_request
      get :edit, params: { id: post.id }
    end

    let!(:user) { FactoryBot.create(:user) }
    before { sign_in user }

    let!(:post) { FactoryBot.create(:post, status: 'Approved') }

    it 'should render :edit' do
      do_request
      expect(response).to render_template :edit
    end
  end

  describe '#update' do
    def do_request
      patch :update, params: { id: post.id, post: post_params }
    end

    let!(:user) { FactoryBot.create(:user) }
    before { sign_in user }

    let!(:category) { FactoryBot.create(:category) }
    let!(:post) { FactoryBot.create(:post, status: 'Approved') }

    context 'with valid params' do
      let!(:post_params) do
        FactoryBot.attributes_for(:post).merge(category_id: category.id)
      end

      it 'should update post' do
        do_request
        expect(post.reload.title).to eq post_params[:title]
        expect(flash[:notice]).to eq 'Post was successfully updated.'
        expect(response).to redirect_to post_path(post)
      end
    end

    context 'with invalid params' do
      let(:post_params) do
        FactoryBot.attributes_for(:post, title: nil).merge(category_id: category.id)
      end

      it 'should not update post and then render :edit' do
        do_request
        expect(post.reload.title).to eq post.title
        expect(flash[:alert]).to eq 'Please fill in all fields.'
        expect(response).to render_template :edit
      end
    end
  end

  describe '#show' do
    def do_request
      get :show, params: { id: post.id }
    end

    let!(:post) { FactoryBot.create(:post) }

    let!(:user) { FactoryBot.create(:user) }
    before { sign_in user }

    it 'should render :show' do
      do_request
      expect(response).to render_template :show
    end
  end

  describe '#destroy' do
    def do_request
      delete :destroy, params: { id: post.id }
    end

    let!(:post) { FactoryBot.create(:post) }

    let!(:user) { FactoryBot.create(:user) }
    before { sign_in user }

    it 'should delete post' do
      expect { do_request }.to change { Post.count }.by(-1)
    end
  end

  describe '#top' do
    def do_request_html
      get :top
    end

    let!(:user) { FactoryBot.create(:user) }
    before { sign_in user }

    context 'get :top' do
      it 'should render :top' do
        do_request_html
        expect(response).to render_template :top
      end
    end

    def do_request_js
      get :top, xhr: true, params: { choice: time }
    end

    let!(:today_post1) { FactoryBot.create(:post, created_at: Time.now, status: 'Approved') }
    let!(:like1) { FactoryBot.create(:like, post: today_post1) }
    let!(:today_post2) { FactoryBot.create(:post, created_at: Time.now, status: 'Approved') }

    context 'with choice is today' do
      let!(:post) { FactoryBot.create(:post, created_at: 1.day.ago, status: 'Approved') }
      let(:time) { 'Today' }

      it 'should return sorted today posts' do
        do_request_js
        expect(assigns(:posts)).to eq([today_post1, today_post2])
      end
    end

    context 'with choice is week' do
      let!(:post) { FactoryBot.create(:post, created_at: Time.now - 1.week, status: 'Approved') }
      let(:time) { 'Week' }

      it 'should return sorted this week posts' do
        do_request_js
        expect(assigns(:posts)).to eq([today_post1, today_post2])
      end
    end

    context 'with choice is month' do
      let!(:post) { FactoryBot.create(:post, created_at: Time.now - 1.month, status: 'Approved') }
      let(:time) { 'Month' }

      it 'should return sorted this month posts' do
        do_request_js
        expect(assigns(:posts)).to eq([today_post1, today_post2])
      end
    end

  end

  describe 'status' do
    def do_request
      get :status
    end

    let!(:another_user) { FactoryBot.create(:user) }
    let!(:user) { FactoryBot.create(:user) }
    before { sign_in user }

    let!(:post1) { FactoryBot.create(:post, user: user) }
    let!(:post2) { FactoryBot.create(:post, user: another_user) }

    it "should return all current user's post status" do
      do_request
      expect(assigns(:posts)).to include(post1)
      expect(response).to render_template :status
    end
  end

end
