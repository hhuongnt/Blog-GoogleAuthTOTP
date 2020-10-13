require 'rails_helper'

RSpec.describe Admin::CategoriesController, type: :controller do
  describe '#index' do
    def do_request
      get :index
    end

    let(:admin) { FactoryBot.create(:user, role: 'admin') }
    let!(:category1) { FactoryBot.create(:category) }
    let!(:category2) { FactoryBot.create(:category) }

    before { sign_in admin }

    it 'should render :index' do
      do_request
      expect(assigns(:categories)).to include(category1, category2)
      expect(response).to render_template :index
    end
  end
end
