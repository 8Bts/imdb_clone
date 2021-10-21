module MoviesHelper
  def user_box
    if Current.user
      render partial: 'user_box', locals: { user: Current.user }
    else
      render inline: '<a href=<%= log_in_path %> class="sign-in-link">Sign In</a>'
    end
  end

  def my_vote(id)
    vote = nil
    vote = Current.user.votes.find_by(movie_id: id) if Current.user
    if vote
      render partial: 'my_vote', locals: { id: id, vote: vote }
    else
      render partial: 'not_rated', locals: { id: id }
    end
  end
end
