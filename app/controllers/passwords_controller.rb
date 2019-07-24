class PasswordsController < Devise::PasswordsController
  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
      respond_with resource, location: after_sending_reset_password_instructions_path_for(resource_name)
    else
      response_to_password_reset_failure resource    
    end
  end

  private

  def after_sending_reset_password_instructions_path_for(resource_name)
    root_path
  end
  
  def response_to_password_reset_failure(resource)
    redirect_back fallback_location: root_path, alert: "Please check email"
  end
end

