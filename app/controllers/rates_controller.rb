class RatesController < ApplicationController
  before_action :prepare_post, only: :create

  def create
    @rate = @post.rates.find_or_initialize_by(user_id: current_user.id)
    if @rate.present?
      @rate.update(rate_params)
    else
      @rate.create(rate_params)
    end

    respond_to do |format|
      format.html
      format.js { render layout: false }
    end
  end

  private

  def prepare_post
    @post = Post.find(params[:post_id])
  end

  def rate_params
    params.require(:rate).permit(:value)
  end
end
