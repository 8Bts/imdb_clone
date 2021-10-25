class VotesController < ApplicationController
  before_action :require_user_logged_in!
  before_action :set_vote, only: %i[update destroy]

  def create
    movie = Movie.find_by(id: params[:movie_id])
    @vote = Vote.new(user_id: Current.user.id, movie_id: params[:movie_id], rating: params[:rating])
    if movie && @vote.save
      render json: @vote, status: :created
    else
      render json: 'Invalid attributes', status: 422
    end
  end

  def update
    @vote.rating = params[:rating]
    if @vote.save
      render json: @vote, status: :created
    else
      render json: 'Invalid attributes', status: 422
    end
  end

  def destroy
    @vote.destroy
    head :no_content
  end

  private

  def set_vote
    @vote = Vote.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: 'Vote not found', status: :not_found
  end
end
