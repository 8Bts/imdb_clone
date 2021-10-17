require 'rails_helper'

RSpec.describe 'Registrations', type: :request do
  let(:valid_user_attributes) { { name: 'Ben', password: '12345678', email: 'ada@das.com' } }
  let(:invalid_user_attributes) { { name: 'Tom' } }

  describe "GET /sign_up" do
    before { get '/sign_up' }

    it "Renders :new template for registration form" do
      assert_template 'authorizations/authorization'
    end
  end

  describe "POST /sign_up" do
    context 'When the request is valid' do
      before do
        @before_count = User.count
        post '/sign_up', params: { user: valid_user_attributes } 
      end

      it 'Creates new User in database' do
        expect(User.count).to_not eq(@before_count)
      end

      it 'Responds with status code 201' do
        expect(response).to have_http_status(:found)
      end

      it 'Redirects to root path' do
        expect(response).to redirect_to(root_path)
      end
    end

    context 'When the request is invalid' do
      let(:before_count) { User.count }
      before { post '/sign_up', params: { user: invalid_user_attributes } }

      it 'Doesn\'t create new User in database' do
        expect(User.count).to eq(before_count)
      end

      it 'Responds with status code 422' do
        expect(response).to have_http_status(422)
      end

      it "Renders :new template for registration form" do
        assert_template 'authorizations/authorization'
      end
    end
  end
end