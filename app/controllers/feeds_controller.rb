class FeedsController < ApplicationController
  include RestrictedAccess

  def index
    @feeds = Feed.all.order(id: :desc).page params[:page]
  end
end
