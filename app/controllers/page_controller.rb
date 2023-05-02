class PageController < ApplicationController
  include RestrictedAccess
  def index
    @topics = Topic.all.order(:name)
    @feeds = Feed.all
  end

end
