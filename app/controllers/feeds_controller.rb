class FeedsController < ApplicationController
  include RestrictedAccess

  def index
    @feeds = Feed.all.order(id: :desc).page params[:page]
    @total_feeds = Feed.all.count
  end
end
