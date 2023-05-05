class StoriesController < ApplicationController
  def index
    @stories = Story.all.order(id: :desc).limit(10)
  end

  def show
    @story = Story.find(params[:id])
    @parsed_story = JSON.parse(@story.stem) if @story.stem
  end

end
