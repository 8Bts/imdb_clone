class CategoriesController < ApplicationController
  before_action :set_category, only: %i[ show update destroy ]

  def show
    @movies = @category.movies
    render template: 'movies/index'
  end

  def create
    @category = Category.new(name: params[:name])
    if @category.save
      flash[:success] = "New Category was successfully created"
      redirect_to root_path
    else
      flash[:error] = "Invalid Category name"
      redirect_to root_path
    end
  end

  def update
      if @category.update(name: params[:name])
        flash[:success] = "Category was successfully updated"
        redirect_to root_path
      else
        flash[:error] = "Invalid Category name"
        redirect_to root_path
      end
  end
 
  def destroy
    if @category.destroy
      flash[:success] = 'Category was successfully deleted.'
      redirect_to root_path
    else
      flash[:error] = 'Something went wrong'
      redirect_to root_path
    end
  end
  
  private

    def set_category
        @category = Category.find_by(name: params[:id])
        redirect_to :movies, status: :not_found unless @category
    end

end