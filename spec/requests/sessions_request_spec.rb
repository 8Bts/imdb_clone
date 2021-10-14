require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  describe "GET /sign_in" do
    before { get '/sign_in' }

    it "Renders :new template for sign in form" do
      assert_template 'sessions/new'
    end
  end

  describe "POST /sign_in" do
    context 'When User exists and credentials are valid' do
      before do
        User.create(name: 'Tom', email: 'tom@hanks.com', password: '12345')
        post '/sign_in', params: { email: 'tom@hanks.com', password: 12345 } 
      end

      it 'Creates new session' do
        expect(session[:user_id]).to_not be_nil
      end

      it 'Responds with status code 201' do
        expect(response).to have_http_status(:found)
      end

      it 'Redirects to root path' do
        expect(response).to redirect_to(root_path)
      end
    end

    context 'When User doesn\'t exist or credentials are invalid' do
      before do
        post '/sign_in', params: { email: 'Tom', password: '12345' } 
      end

      it 'Doesn\'t create new session' do
        expect(session[:user_id]).to be_nil
      end

      it 'Responds with status code 422' do
        expect(response).to have_http_status(422)
      end

      it "Renders :new template for sign in form" do
        assert_template 'sessions/new'
      end
    end
  end

  describe "DELETE /log_out" do
    before do
      User.create(name: 'Tom', email: 'tom@hanks.com', password: '12345')
      post '/sign_in', params: { email: 'tom@hanks.com', password: 12345 } 
      delete '/logout' 
    end

    it "Empties the session" do
      expect(session[:user_id]).to be_nil
    end

    it 'Redirects to root path' do
      expect(response).to redirect_to(root_path)
    end
  end
end