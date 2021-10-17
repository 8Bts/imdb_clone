require 'rails_helper'

RSpec.describe "Movies", type: :request do
  let!(:movie) { create(:movie) }
  let(:movie_id) { movie.id }
  
  describe 'GET /movies' do
    before { get '/movies' }

    it 'renders index template' do
      assert_template 'index'
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /movies/:id' do
    before { get "/movies/#{movie_id}" }
    context 'when the record exists' do
      it 'renders show template' do
        assert_template 'show'
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:movie_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'POST /movies' do
    let(:valid_attributes) { movie.attributes.merge(category: 'Action') }

    context 'when the request is valid' do
      before do
        Category.create(name: 'Action')
        post '/movies', params: valid_attributes
      end

      it 'creates new record' do
        expect(Movie.find(movie_id)).to_not be_nil
      end

      it 'renders movies/index with flash[:success] set' do
        assert_template 'index'
        expect(flash[:success]).to eq('New Movie successfully created')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before do
        Category.create(name: 'Romance')
        post '/movies', params: { title: 'Green Mile' }
      end

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end
    end
  end

  describe 'PUT /movies/:id' do
    let(:valid_attributes) { movie.attributes.merge(category: 'Action') }

    context 'when the record exists' do
      before do
        Movie.find(movie_id).categories << Category.create(name: 'Sci-Fi')
        put "/movies/#{movie_id}", params: valid_attributes
      end

      it 'updates the record' do
        expect(Movie.find(movie_id).categories.first.name).to eq('Action')
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  describe 'DELETE /movies/:id' do
    before { delete "/movies/#{movie_id}" }

    it 'deletes record' do
      expect(Movie.find(movie_id)).to be_nil
    end

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
