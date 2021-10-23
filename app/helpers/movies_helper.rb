module MoviesHelper
  def user_box
    if Current.user
      render partial: 'movies/user_box', locals: { user: Current.user }
    else
      render inline: '<a href=<%= log_in_path %> class="sign-in-link">Sign In</a>'
    end
  end

  def my_vote(id)
    vote = nil
    vote = Current.user.votes.find_by(movie_id: id) if Current.user
    if vote
      render partial: 'movies/my_vote', locals: { id: id, vote: vote }
    else
      render partial: 'movies/not_rated', locals: { id: id }
    end
  end

  def ap_movies
    render 'shared/ap_movies' if Current.user && Current.user.admin_level > 0
  end

  def ap_movie_page(movie_id)
    render partial: 'shared/ap_movie_page', locals: { movie_id: movie_id } if Current.user && Current.user.admin_level > 0
  end

  def total_pages
    count = Movie.all.count
    rem = (count % 5 == 0) ? 0 : 1
    t_pages = count / 5 + rem
    t_pages
  end

  def pagination(current_page)
    pages = []
    total = total_pages
    return if total == 1
    
    _from = current_page - (current_page % 5) + 1
    _to = _from + 4  

    n_class = (current_page == total) ? 'page-item disabled' : 'page-item'
    p_class = (current_page == 1) ? 'page-item disabled' : 'page-item'

    (_from.._to).each do |v|
      break if v > total
      _class = (current_page == v) ? 'active' : ''
      pages.push({ p_class: _class, p_index: v })
    end

    render partial: 'shared/pagination', locals: { pages: pages, page: current_page, next_class: n_class, prev_class: p_class }
  end
end
