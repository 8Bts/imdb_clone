class CategoriesController < ApplicationController
  before_action :set_category, only: %i[show update destroy]
  before_action :check_admin_level, except: %i[index show]

  def show
    @page = params[:page].to_i

    @page = 1 if @page.zero? or @page.negative?
    @page = total_pages if @page > total_pages
    offset = (@page * 5) - 5

    @movies = @category.movies.includes(:votes).offset(offset).limit(5).sort { |a, b| b.rating <=> a.rating }
    @categories = Category.all
    @genre = @category.name
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
