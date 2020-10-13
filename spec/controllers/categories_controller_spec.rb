require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  describe '#index' do
    def do_request
      get :index
    end

    let!(:user) { FactoryBot.create(:user) }
    before { sign_in user }

    let!(:category1) { FactoryBot.create(:category) }
    let!(:category2) { FactoryBot.create(:category) }

    it 'should return categories list' do
      do_request
      expect(assigns(:categories)).to eq([category1, category2])
    end
  end

  describe '#create' do
    def do_request
      post :create, params: category_params
    end

    let!(:user) { FactoryBot.create(:user) }
    before { sign_in user }

    context 'with valid params' do
      let(:category_params) do
        {
          category: FactoryBot.attributes_for(:category)
        }
      end

      it 'should create new category' do
        expect { do_request }.to change { Category.count }.by(1)
        expect(flash[:notice]).to eq 'Category was successfully created.'
        expect(response).to redirect_to categories_path
      end
    end

    context 'with invalid params' do
      let(:category_params) do
        {
          category: FactoryBot.attributes_for(:category, name: nil)
        }
      end

      it 'should not create new category and then render :new' do
        expect { do_request }.to_not change { Category.count }
        expect(flash[:alert]).to eq 'Category cannot be null or it maybe already exists.'
        expect(response).to redirect_to categories_path
      end
    end
  end

  describe 'show' do
    def do_request
      get :show, params: { id: category.id }
    end

    let!(:user) { FactoryBot.create(:user) }
    before { sign_in user }

    let!(:category) { FactoryBot.create(:category) }

    it 'should render :show' do
      do_request
      expect(response).to render_template :show
    end
  end

end
