class ImaginationsController < ApplicationController
  include RestrictedAccess

  def index
    @imaginations= Imagination.successful.order(id: :desc).page params[:page]
    @total_imaginations = Imagination.successful.count
  end
end
