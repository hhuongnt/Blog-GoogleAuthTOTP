class UsersController < ApplicationController
  before_action :prepare_user, only: %i[show]

  def show; end

  private

  def prepare_user
    @user = User.find(params[:id])
  end
end
