require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

#create

  describe 'comments#create action' do
    it 'should require logged in user' do
      gram = FactoryBot.create(:gram)      
      post :create, params: {gram_id: gram.id, comment: {message: 'user logged in'}}
      expect(response).to redirect_to new_user_session_path
    end

    it 'should create new comment' do
      gram = FactoryBot.create(:gram)
      user = FactoryBot.create(:user)
      sign_in user
      post :create, params: {gram_id: gram.id, comment: {message: 'new comment'}}
      expect(response).to redirect_to root_path
      expect(gram.comments.length).to eq 1
      expect(gram.comments.first.message).to eq 'new comment'
    end

   it 'should return http status gram not found' do
      user = FactoryBot.create(:user)
      sign_in user
      post :create, params: {gram_id: 'none', comment: {message: 'gram not found'}}
      expect(response).to have_http_status(:not_found)
    end
  end

end
