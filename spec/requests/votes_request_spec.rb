require 'rails_helper'

RSpec.describe 'Votes', type: :request do
let(:movie) { create(:movie) }
let(:user) { create(:user) }

  describe 'POST /votes' do
    let(:valid_attributes) { { rating: 10, movie_id: movie.id } }

    context 'when the request is valid' do
      before do
        get log_in_path
        session[:user_id] = user.id
        post '/votes', params: { vote: valid_attributes }
      end

      it 'creates new vote record and create association with relevant User and Movie' do
        vote = Vote.find_by(user_id: user.id, movie_id: movie.id)
        expect(vote).to_not be_nil
        expect(User.find(user.id).votes).to include(vote)
        expect(Movie.find(movie.id).votes).to include(vote)
      end

      it 'sets flash[:success]' do
        expect(flash[:success]).to eq('Vote was successfully submitted')
      end

      it 'returns status code 302' do
        expect(response).to have_http_status(302)
      end
    end

    context 'when the request is invalid' do
      before do
        post '/votes', params: { vote: { rating: 15, movie_id: 100 } }
      end

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end
    end
  end

  
  describe 'DELETE /votes/:id' do
    let(:vote) { Vote.create(rating: 10, user_id: user.id, movie_id: movie.id) }

    before do
      delete "/votes/#{vote.id}"
    end

    it 'deletes record' do
      expect(Vote.find_by(id: vote.id)).to be_nil
    end

    it 'returns status code 302' do
      expect(response).to have_http_status(302)
    end
  end
end
