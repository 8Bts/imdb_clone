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
        @session_before = session[:user_id]
        User.create('Tom', 'tom@hanks.com', '12345')
        post '/sign_in', params: { email: 'tom@hanks.com', password: 12345 } 
      end

      it 'Creates new session' do
        expect(@session_before)).to_not eq(session[:user_id])
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
        @before_session = session[:user_id]
        post '/sign_in', params: { email: 'Tom', password: '12345' } 
      end

      it 'Doesn\'t create new session' do
        expect(@before_session).to eq(session[:user_id])
      end

      it 'Responds with status code 422' do
        expect(response).to have_http_status(422)
      end

      it "Renders :new template for sign in form" do
        assert_template 'session/new'
      end
    end
  end

  describe "DELETE /log_out" do
    before do
      session[:user_id] = 1
      delete '/log_out' 
    end

    it "Empties the session" do
      expect(session[:user_id]).to be_nil
    end

    it 'Redirects to root path' do
      expect(response).to redirect_to(root_path)
    end
  end
end