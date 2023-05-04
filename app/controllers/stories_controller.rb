class StoriesController < ApplicationController
  def index
    @stories = Story.all.order(id: :desc).limit(10)
  end

end
