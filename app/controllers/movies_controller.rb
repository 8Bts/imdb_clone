class MoviesController < ApplicationController
  before_action :set_movie, only: %i[show edit update destroy]
  before_action :check_admin_level, except: %i[index show]

  # GET /movies or /movies.json
  def index
    @page = params[:page].to_i

    @page = 1 if @page.zero? or @page.negative?
    @page = total_pages if @page > total_pages
    offset = (@page * 5) - 5
    @movies = Movie.includes(:votes).offset(offset).limit(5).sort { |a, b| b.rating <=> a.rating }
    @categories = Category.all
    @genre = 'All'
  end

  # GET /movies/1 or /movies/1.json
  def show; end

  # GET /movies/new
  def new
    @movie = Movie.new
  end

  # GET /movies/1/edit
  def edit; end

  # POST /movies or /movies.json
  def create
    @movie = Movie.new(movie_params)
    params[:movie][:categories].each do |c|
      category = Category.find_by(name: c)
      if category
        @movie.categories << category
      else
        @movie.errors.add(:base, :invalid, message: "#{c} is invalid category name")
        render :new, status: :unprocessable_entity
        return
      end
    end
    if @movie.save
      flash[:success] = "#{movie_params[:title]} was successfully created!"
      redirect_to movies_url
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /movies/1 or /movies/1.json
  def update
    @movie.categories.delete_all
    params[:movie][:categories].each do |c|
      category = Category.find_by(name: c)
      if category
        @movie.categories << category unless @movie.categories.include?(category)
      else
        @movie.errors.add(:base, :invalid, message: "#{c} is invalid category name")
        render :new, status: :unprocessable_entity
        return
      end
    end
    if @movie.update(movie_params)
      redirect_to @movie, notice: 'Movie was successfully updated!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /movies/1 or /movies/1.json
  def destroy
    @movie.destroy
    redirect_to movies_url, alert: "#{@movie.title} was successfully destroyed!"
  end

  private

  def set_movie
    @movie = Movie.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to :movies, status: :not_found
  end

  def movie_params
    params.require(:movie).permit(:title, :description, :image, :categories)
  end
end
