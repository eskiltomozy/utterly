require 'rails_helper'

RSpec.describe GramsController, type: :controller do
  describe 'grams#index action' do
    it 'should show the page' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'grams#new action' do
    it 'should require logged in user' do
      get :new
      expect(response).to redirect_to new_user_session_path
    end

    it 'should show new form' do
      user = User.create(
        email:                 'fakeuser@gmail.com',
        password:              'secretPassword',
        password_confirmation: 'secretPassword'
      )
      sign_in user

      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe 'grams#create action' do
    it 'should require logged in user' do
      post :create, params: {gram: {message: 'Hello'}}
      expect(response).to redirect_to new_user_session_path
    end

    it 'should create new gram' do
      user = User.create(
        email:                 'fakeuser@gmail.com',
        password:              'secretPassword',
        password_confirmation: 'secretPassword'
      )
      sign_in user

      post :create, params: {gram: {message: 'Hello'}}
      expect(response).to redirect_to root_path
      gram = Gram.last
      expect(gram.message).to eq('Hello')
      expect(gram.user).to eq(user)
    end

    it 'should validate errors' do
      user = User.create(
        email:                 'fakeuser@gmail.com',
        password:              'secretPassword',
        password_confirmation: 'secretPassword'
      )
      sign_in user

      gram_count = Gram.count
      post :create, params: {gram: {message: ''}}
      expect(response).to have_http_status(:unprocessable_entity)
      expect(gram_count).to eq Gram.count
    end
  end
end
