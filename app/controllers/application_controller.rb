class ApplicationController < ActionController::Base
  layout :layout_by_resource

  private

  def layout_by_resource
    if devise_controller?
      'devise_layout' # Name of the layout for Devise controllers
    else
      'application' # Default layout
    end
  end
end
