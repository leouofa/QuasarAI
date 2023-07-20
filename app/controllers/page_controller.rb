class PageController < ApplicationController
  include RestrictedAccess
  def index
    @topics = Topic.with_active_subtopic.order(:name)
  end
end
