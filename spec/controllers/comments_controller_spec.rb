require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe '#create' do
    def do_request
      post :create, params: { post_id: article.id, comment: comment_params }
    end

    let!(:user) { FactoryBot.create(:user) }
    before { sign_in user }

    let!(:article) { FactoryBot.create(:post) }

    context 'with valid params' do
      let(:comment_params) { FactoryBot.attributes_for(:comment) }

      it 'should create new comment' do
        expect { do_request }.to change { Comment.count }.by(1)
        expect(flash[:notice]).to eq 'Comment was successfully created.'
      end
    end

    context 'with invalid params' do
      let(:comment_params) { FactoryBot.attributes_for(:comment, content: nil) }

      it 'should not create new comment' do
        expect { do_request }.to_not change { Comment.count }
        expect(flash[:alert]).to eq "Comment can't be blank."
      end
    end
  end

end
