require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  describe '#index' do
    def do_request
      get :index
    end

    let(:admin) { FactoryBot.create(:user, role: 'admin') }
    let!(:user1) { FactoryBot.create(:user) }
    let!(:user2) { FactoryBot.create(:user) }

    before do
      sign_in admin
      do_request
    end

    it 'render users list' do
      expect(assigns(:users)).to include(user1, user2)
      expect(response).to render_template :index
    end
  end

  describe '#show' do
    def do_request
      get :show, params: { id: user.id }
    end

    let!(:user) { FactoryBot.create(:user) }
    let(:admin) { FactoryBot.create(:user, role: 'admin') }

    before { sign_in admin }

    it 'should render :show' do
      do_request
      expect(response).to render_template :show
    end
  end

  describe '#destroy' do
    def do_request
      delete :destroy, params: { id: user.id }
    end

    let!(:user) { FactoryBot.create(:user) }
    let!(:admin) { FactoryBot.create(:user, role: 'admin') }

    before { sign_in admin }

    it 'should delete user' do
      expect { do_request }.to change { User.count }.by(-1)
      expect(flash[:notice]).to eq 'User was successfully deleted.'
      expect(response).to redirect_to admin_users_path
    end
  end

end
