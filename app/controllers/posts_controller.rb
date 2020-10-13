class PostsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]
  before_action :prepare_approved_posts, only: %i[index top]
  before_action :prepare_post, only: %i[edit update destroy]
  before_action :prepare_categories, only: %i[new edit]

  def index
    @posts = Post.search(params[:search]) if params[:search].present?

    respond_to do |format|
      format.html
      format.js { render layout: false }
    end
  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to post_path(@post), notice: 'Post was successfully created.'
    else
      prepare_categories
      flash[:alert] = @post.errors.full_messages.join(', ')
      render :new
    end
  end

  def edit; end

  def update
    if @post.update(post_params)
      redirect_to post_path(@post), notice: 'Post was successfully updated.'
    else
      prepare_categories
      flash[:alert] = @post.errors.full_messages.join(', ')
      render :edit
    end
  end

  def show
    @post = Post.find_by(id: params[:id])

    @rating_point = @post.rating_point(current_user) || 0
    @pre_like = @post.likes.find { |like| like.user_id == current_user.id }
  end

  def destroy
    @post.destroy

    flash[:notice] = 'Post was successfully destroyed.'
    redirect_back(fallback_location: root_path)
  end

  def top
    @posts = if params[:choice] == 'Today'
               @posts.where('created_at BETWEEN ? AND ?', Time.now.beginning_of_day, Time.now)
             elsif params[:choice] == 'Week'
               @posts.where('created_at BETWEEN ? AND ?', Time.now.beginning_of_week, Time.now.end_of_week)
             elsif params[:choice] == 'Month'
               @posts.where('created_at BETWEEN ? AND ?', Time.now.beginning_of_month, Time.now.end_of_month)
             else
               Post.none
             end.sort_by { |post| -post.likes.count }.first 3

    respond_to do |format|
      format.html
      format.js { render layout: false }
    end
  end

  def status
    @posts = current_user.posts
  end

  private

  def post_params
    params[:status] ||= "New"
    params.require(:post).permit(:title, :content, :image, :category_id, :status)
  end

  def prepare_post
    @post = if current_user.admin?
              Post.find(params[:id])
            else
              current_user.posts.find(params[:id])
            end
  end

  def prepare_categories
    @categories = Category.all
  end

  def prepare_approved_posts
    @posts = Post.approved
  end
end
