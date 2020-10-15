class Users::RegistrationsController < Devise::RegistrationsController
  prepend_before_action :check_captcha, only: [:create]
  before_action :prepare_user, only: %i[confirm_two_factor confirm_two_factor_update]
  def confirm_two_factor
    self.resource = current_user
  end

  def confirm_two_factor_update
    if @user.authenticate_totp(params[:code])
      @user.update(unconfirmed_two_factor: false)
      self.resource = @user
      set_flash_message!(:notice, :signed_in)
      sign_in(resource_name, resource)
      redirect_to root_path
    else
      redirect_to confirm_two_factor_path, alert: 'Wrong code! Please try again.'
    end
  end

  protected

  def account_update_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :gender,
      :age,
      :avatar,
      :email,
      :password,
      :password_confirmation,
      :current_password,
      :two_factor_enabled,
      :phone_number
    )
  end

  private

  def check_captcha
    return if verify_recaptcha

    self.resource = resource_class.new sign_up_params
    respond_with_navigational(resource) { render :new }
  end

  def prepare_user
    @user = User.find(session[:user].dig('id'))
  end
end
