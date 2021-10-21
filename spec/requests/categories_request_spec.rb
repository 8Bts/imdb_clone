require 'rails_helper'

RSpec.describe 'Categories', type: :request do
  let(:category) { Category.create(name: 'Action') }
  let(:category_name) { category.name }

  describe 'GET /genres/:id' do
    before { get "/genres/#{category_name}" }
    context 'when the record exists' do
      it 'renders index template of movies' do
        assert_template 'movies/index'
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:category_name) { 'Musical' }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'POST /genres' do
    context 'when the request is valid' do
      before do
        post '/genres', params: { name: 'History' }
      end

      it 'creates new record' do
        expect(Category.find_by(name: 'History')).to_not be_nil
      end

      it 'renders movies/index with flash[:success] set' do
        expect(response).to redirect_to(root_path)
        expect(flash[:success]).to eq('New Category was successfully created')
      end

      it 'returns status code 302' do
        expect(response).to have_http_status(302)
      end
    end

    context 'when the request is invalid' do
      before do
        post '/genres', params: { name: 'X' }
      end

      it 'redirects to root path with flash[:error]' do
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq('Invalid Category name')
      end
    end
  end

  describe 'PUT /genres/:id' do
    context 'when the record exists and attributes are valid' do
      before do
        put "/genres/#{category_name}", params: { name: 'Drama' }
      end

      it 'updates the record' do
        expect(Category.find_by(name: 'Drama')).to_not be_nil
      end

      it 'returns status code 302' do
        expect(response).to have_http_status(302)
      end
    end

    context 'when the record doesn\'t exist or attributes are invalid' do
      it 'Doesn\'t update record when attributes are invalid' do
        put '/genres/Action', params: { name: 'X' }
        expect(Category.find_by(name: 'X')).to be_nil
      end

      it 'Doesn\'t update record when record not found' do
        put '/genres/Thriller', params: { name: 'Horror' }
        expect(Category.find_by(name: 'Horror')).to be_nil
      end
    end
  end

  describe 'DELETE /genres/:id' do
    before { delete "/genres/#{category_name}" }

    it 'deletes record' do
      expect(Category.find_by(name: category_name)).to be_nil
    end

    it 'returns status code 302' do
      expect(response).to have_http_status(302)
    end
  end
end
