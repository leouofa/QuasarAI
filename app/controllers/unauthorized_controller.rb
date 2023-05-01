class UnauthorizedController < ApplicationController
  def index
    redirect_to root_path if current_user.has_access?
  end
end
