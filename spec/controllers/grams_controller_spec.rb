require 'rails_helper'

RSpec.describe GramsController, type: :controller do

#index

  describe 'grams#index action' do
    it 'should show the page' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

#new

  describe 'grams#new action' do
    it 'should require logged in user' do
      get :new
      expect(response).to redirect_to new_user_session_path
    end

    it 'should show new form' do
      user = FactoryBot.create(:user)
      sign_in user

      get :new
      expect(response).to have_http_status(:success)
    end
  end

#create

  describe 'grams#create action' do
    it 'should require logged in user' do
      post :create, params: {gram: {message: 'Hello'}}
      expect(response).to redirect_to new_user_session_path
    end

    it 'should create new gram' do
      user = FactoryBot.create(:user)
      sign_in user

      post :create, params: {gram: {message: 'Hello'}}
      expect(response).to redirect_to root_path
      gram = Gram.last
      expect(gram.message).to eq('Hello')
      expect(gram.user).to eq(user)
    end

    it 'should validate errors' do
      user = FactoryBot.create(:user)
      sign_in user

      gram_count = Gram.count
      post :create, params: {gram: {message: ''}}
      expect(response).to have_http_status(:unprocessable_entity)
      expect(gram_count).to eq Gram.count
    end
  end

#show

  describe 'grams#show action' do
    it 'should show gram found' do
      gram = FactoryBot.create(:gram)
      get :show, params: {id: gram.id}
      expect(response).to have_http_status(:success)
    end

    it 'should show 404 error gram not found' do
      get :show, params: {id: 'NOPE'}
      expect(response).to have_http_status(:not_found)
    end
  end

#edit

  describe 'grams#edit action' do
    it 'should show edit form' do
      gram = FactoryBot.create(:gram)
      get :edit, params: {id: gram.id}
      expect(response).to have_http_status(:success)
    end

    it 'should show 404 error edit form not found' do
      get :edit, params: {id: 'NOPE'}
      expect(response).to have_http_status(:not_found)
    end
  end

#update

  describe 'grams#update action' do
    it 'should show gram update' do
      gram = FactoryBot.create(:gram, message: 'Initial Value')
      patch :update, params: {id: gram.id, gram: {message: 'Updated'}}
      expect(response).to redirect_to root_path
      gram.reload
      expect(gram.message).to eq 'Updated'
    end

    it 'should show 404 error gram not found' do
      patch :update, params: {id: 'NOPE', gram: {message: 'Updated'}}
      expect(response).to have_http_status(:not_found)
    end

    it 'should render edit form unprocessable_entity' do
      gram = FactoryBot.create(:gram, message: 'Initial Value')
      patch :update, params: {id: gram.id, gram: {message: ''}}
      expect(response).to have_http_status(:unprocessable_entity)
      gram.reload
      expect(gram.message).to eq 'Initial Value'
    end
  end

end
