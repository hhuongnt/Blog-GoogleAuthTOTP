class CategoriesController < ApplicationController
  def index
    @categories = Category.all
  end

  def create
    @category = current_user.categories.new(category_params)

    if @category.save
      redirect_to categories_path, notice: 'Category was successfully created.'
    else
      redirect_to categories_path, alert: 'Category cannot be null or it maybe already exists.'
    end
  end

  def show
    @category = Category.find(params[:id])
    @posts = @category.posts.approved
  end

  private

  def category_params
    params.require(:category).permit(:name, :description)
  end

end
