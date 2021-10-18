class VotesController < ApplicationController
  def create
  end

  def destroy
  end

  private

  def vote_params
    params.require(:vote).permit(:rating, :movie_id)
  end
end