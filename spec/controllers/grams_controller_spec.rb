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
      expect(response).to redirect_to root_path
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
      post :create, params: {gram: {message: 'user logged in'}}
      expect(response).to redirect_to root_path
    end

    it 'should create new gram' do
      user = FactoryBot.create(:user)
      sign_in user
      post :create, params: {gram: {message: 'new gram', image: fixture_file_upload('/image.png', 'image/png')}}
      expect(response).to redirect_to root_path
      gram = Gram.last
      expect(gram.message).to eq('new gram')
      expect(gram.user).to eq(user)
    end

    it 'should validate errors' do
      user = FactoryBot.create(:user)
      sign_in user
      gram_count = Gram.count
      post :create, params: {gram: {message: ''}}
      expect(response).to have_http_status(:found)
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

    it 'should return 404 error gram not found' do
      get :show, params: {id: 'not found'}
      expect(response).to have_http_status(:not_found)
    end
  end

#edit

  describe 'grams#edit action' do
    it 'should authenticate user' do
      gram = FactoryBot.create(:gram)
      user = FactoryBot.create(:user)
      sign_in user
      get :edit, params: {id: gram.id}
      expect(response).to have_http_status(:forbidden)
    end    

    it 'should authenticate user before edit gram' do
      gram = FactoryBot.create(:gram)
      get :edit, params: {id: gram.id}
      expect(response).to redirect_to root_path
    end

    it 'should show edit form' do
      gram = FactoryBot.create(:gram)
      sign_in gram.user
      get :edit, params: {id: gram.id}
      expect(response).to have_http_status(:success)
    end

    it 'should return 404 error edit form not found' do
      user = FactoryBot.create(:user)
      sign_in user
      get :edit, params: {id: 'not found'}
      expect(response).to have_http_status(:not_found)
    end
  end

#update

  describe 'grams#update action' do
    it 'should authenticate user' do
      gram = FactoryBot.create(:gram)
      user = FactoryBot.create(:user)
      sign_in user
      patch :update, params: {id: gram.id, gram: {message: 'wrong user'}}
      expect(response).to have_http_status(:forbidden)
    end    

    it 'should authenticate user before update gram' do
      gram = FactoryBot.create(:gram)
      patch :update, params: {id: gram.id, gram: {message: 'wrong gram user'}}
      expect(response).to redirect_to root_path
    end

    it 'should show gram update' do
      gram = FactoryBot.create(:gram, message: 'initial value')
      sign_in gram.user
      patch :update, params: {id: gram.id, gram: {message: 'gram updated'}}
      expect(response).to redirect_to gram_path(gram)
      gram.reload
      expect(gram.message).to eq 'gram updated'
    end

    it 'should return 404 error gram not found' do
      user = FactoryBot.create(:user)
      sign_in user
      patch :update, params: {id: 'none', gram: {message: 'gram not found'}}
      expect(response).to have_http_status(:not_found)
    end

    it 'should render edit form unprocessable_entity' do
      gram = FactoryBot.create(:gram, message: 'initial value')
      sign_in gram.user
      patch :update, params: {id: gram.id, gram: {message: ''}}
      expect(response).to have_http_status(:unprocessable_entity)
      gram.reload
      expect(gram.message).to eq 'initial value'
    end
  end

#update

  describe 'grams#destroy action' do
    it 'should authenticate user' do
      gram = FactoryBot.create(:gram)
      user = FactoryBot.create(:user)
      sign_in user
      delete :destroy, params: {id: gram.id}
      expect(response).to have_http_status(:forbidden)
    end  

    it 'should authenticate user before destroy gram' do
      gram = FactoryBot.create(:gram)
      delete :destroy, params: {id: gram.id}
      expect(response).to redirect_to root_path
    end

    it 'should destroy gram' do
      gram = FactoryBot.create(:gram)
      sign_in gram.user
      delete :destroy, params: {id: gram.id}
      expect(response).to redirect_to root_path
      gram = Gram.find_by_id(gram.id)
      expect(gram).to eq nil
    end

    it 'should return 404 error specified gram id not found' do
      user = FactoryBot.create(:user)
      sign_in user
      delete :destroy, params: {id: 'gram deleted'}
      expect(response).to have_http_status(:not_found)
    end
  end

end
