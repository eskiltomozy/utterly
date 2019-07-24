class ApplicationController < ActionController::Base
  private

  helper_method :resource_name, :resource, :devise_mapping, :resource_class

  def resource_name
    :user
  end
 
  def resource
    @resource ||= User.new
  end

  def resource_class
    User
  end
 
  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def render_not_found(status=:not_found)
    render plain: "#{status.to_s.titleize} … o.O", status: status
  end
end
