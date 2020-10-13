class Admin::UsersController < Admin::BaseController
  before_action :prepare_user, only: %i[edit update show destroy]

  def index
    @users = User.all
  end

  def edit
  end

  def update
    @user.update(user_params)

    if @user.save
      redirect_to admin_user_path(@user), notice: 'Update successfully.'
    end
  end

  def show; end

  def destroy
    if @user.destroy
      flash[:notice] = 'User was successfully deleted.'
      redirect_back(fallback_location: admin_users_path)
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :age, :gender, :email)
  end

  def prepare_user
    @user = User.find(params[:id])
  end
end
