class VotesController < ApplicationController
  before_action :require_user_logged_in!

  def create
    movie = Movie.find_by(id: vote_params[:movie_id])
    if movie
      @vote = Vote.create(vote_params.merge(user_id: Current.user.id))
      Current.user.votes << @vote
      respond_to do |format|
        format.js
        format.json { render json: @vote, status: :created }
        format.html { redirect_to root_path }
      end
    end
  end

  def destroy
    vote = Vote.find_by(id: params[:id])
    if vote
      vote.destroy
      respond_to do |format|
        format.js
        format.html { redirect_to root_path }
      end
    end
  end

  private

  def vote_params
    params.require(:vote).permit(:rating, :movie_id)
  end
end