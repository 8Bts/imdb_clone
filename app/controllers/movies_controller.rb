class MoviesController < ApplicationController
  before_action :set_movie, only: %i[ show edit update destroy ]

  # GET /movies or /movies.json
  def index
    @movies = Movie.all
  end

  # GET /movies/1 or /movies/1.json
  def show
  end

  # GET /movies/new
  def new
    @movie = Movie.new
  end

  # GET /movies/1/edit
  def edit
  end

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
      flash[:success] = "New Movie was successfully created"
      redirect_to movies_url
    else
      render :new, status: :unprocessable_entity
      p @movie.errors.full_messages
    end
  end

  # PATCH/PUT /movies/1 or /movies/1.json
  def update
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
      redirect_to @movie, notice: "Movie was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /movies/1 or /movies/1.json
  def destroy
    @movie.destroy
    redirect_to movies_url, notice: "Movie was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movie
      begin
        @movie = Movie.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        redirect_to :movies, status: :not_found
      end
    end

    # Only allow a list of trusted parameters through.
    def movie_params
      params.require(:movie).permit(:title, :description, :image)
    end
end
