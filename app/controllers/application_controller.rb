class ApplicationController < ActionController::Base

  include Application::GloballyCacheable
  include Application::RequestHandling
  include Application::LoadMiscellany

  protect_from_forgery with: :exception

  protected

  # Determine if an admin page is showing
  def looking_at_admin?
    params[:controller].split("/").first.eql? "admin"
  end

end
