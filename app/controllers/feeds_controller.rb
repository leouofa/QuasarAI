class FeedsController < ApplicationController
  include RestrictedAccess

  def index
    @feeds = Feed.viewable.order(id: :desc).page params[:page]
    @total_feeds = Feed.viewable.count
  end
end
