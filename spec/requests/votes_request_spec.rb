require 'rails_helper'

RSpec.describe 'Votes', type: :request do
  let(:movie) { create(:movie) }
  let(:user) { create(:user) }

  def set_session(vars = {})
    post test_session_path, params: { session_vars: vars }
    expect(response).to have_http_status(:created)

    vars.each_key do |var|
      expect(session[var]).to be_present
    end
  end

  describe 'POST /votes' do
    let(:valid_attributes) { { rating: 10, movie_id: movie.id } }

    context 'when the request is valid' do
      before do
        set_session(user_id: user.id)
        post '/votes', params: valid_attributes
      end

      it 'creates new vote record and create association with relevant User and Movie' do
        vote = Vote.find_by(user_id: user.id, movie_id: movie.id)
        expect(vote).to_not be_nil
        expect(User.find(user.id).votes).to include(vote)
        expect(Movie.find(movie.id).votes).to include(vote)
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(201)
      end
    end
  end

  describe 'DELETE /votes/:id' do
    let(:vote) { Vote.create(rating: 10, user_id: user.id, movie_id: movie.id) }

    before do
      set_session(user_id: user.id)
      delete "/votes/#{vote.id}"
    end

    it 'deletes record' do
      expect(Vote.find_by(id: vote.id)).to be_nil
    end

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
