class CategoriesController < ApplicationController
  before_action :set_category, only: %i[show update destroy]

  def show
    @movies = @category.movies
    render template: 'movies/index'
  end

  def create
    @category = Category.new(name: params[:name])
    if @category.save
      flash[:success] = 'New Category was successfully created'
    else
      flash[:error] = 'Invalid Category name'
    end
    redirect_to root_path
  end

  def update
    if @category.update(name: params[:name])
      flash[:success] = 'Category was successfully updated'
    else
      flash[:error] = 'Invalid Category name'
    end
    redirect_to root_path
  end

  def destroy
    if @category.destroy
      flash[:success] = 'Category was successfully deleted.'
    else
      flash[:error] = 'Something went wrong'
    end
    redirect_to root_path
  end

  private

  def set_category
    @category = Category.find_by(name: params[:id])
    redirect_to :movies, status: :not_found unless @category
  end
end
