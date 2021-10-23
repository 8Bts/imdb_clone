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
end
