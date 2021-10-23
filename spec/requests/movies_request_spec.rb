require 'rails_helper'

RSpec.describe 'Movies', type: :request do
  let!(:movie) { create(:movie) }
  let(:movie_id) { movie.id }
  let(:user) { create(:user) }
 
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
    file = Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/fixtures/myfiles/test.jpg')), 'image/jpeg')
    let(:valid_attributes) { movie.attributes.merge(title: Faker::Movie.title, categories: %w[Action Adventure], image: file) }
    
    context 'when the request is valid' do
      before do
        set_session(user_id: user.id)
        Category.create(name: 'Action')
        Category.create(name: 'Adventure')
        post '/movies', params: { movie: valid_attributes }
      end

      it 'creates new record' do
        expect(Movie.find_by(title: valid_attributes[:title])).to_not be_nil
      end

      it 'renders movies/index with flash[:success] set' do
        expect(response).to redirect_to(:movies)
        expect(flash[:success]).to eq('New Movie was successfully created')
      end

      it 'returns status code 302' do
        expect(response).to have_http_status(302)
      end
    end

    context 'when the request is invalid' do
      before do
        set_session(user_id: user.id)
        post '/movies', params: { movie: { title: 'Green Mile', categories: [] } }
      end

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end
    end
  end

  describe 'PUT /movies/:id' do
    let(:valid_attributes) { movie.attributes.merge(title: Faker::Movie.title, categories: ['Action']) }

    context 'when the record exists' do
      before do
        set_session(user_id: user.id)
        Category.create(name: 'Action')
        put "/movies/#{movie_id}", params: { movie: valid_attributes }
      end

      it 'updates the record' do
        expect(Movie.find(movie_id).categories.first.name).to eq('Action')
      end

      it 'returns status code 302' do
        expect(response).to have_http_status(302)
      end
    end
  end

  describe 'DELETE /movies/:id' do
    before do 
      set_session(user_id: user.id)
      delete "/movies/#{movie_id}"
    end

    it 'deletes record' do
      expect(Movie.find_by(id: movie_id)).to be_nil
    end

    it 'returns status code 302' do
      expect(response).to have_http_status(302)
    end
  end
end
