class Users::SessionsController < Devise::SessionsController
  def create
    user = User.find_by_email(params[:user][:email])
    if user&.two_factor_enabled?
      if user.valid_password?(params[:user][:password])
        session[:user] = user
        redirect_to confirm_two_factor_path
      else
        flash[:alert] = 'Invalid Email or password.'
        redirect_to new_user_session_path
      end
    else
      self.resource = warden.authenticate!(auth_options)
      set_flash_message!(:notice, :signed_in)
      sign_in(resource_name, resource)
      yield resource if block_given?
      respond_with resource, location: after_sign_in_path_for(resource)
    end
  end
end
