class ApplicationController < ActionController::Base

  private

  def render_not_found(status=:not_found)
    render plain: "#{status.to_s.titleize} … o.O", status: status
  end

end
