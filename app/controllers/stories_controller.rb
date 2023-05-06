class StoriesController < ApplicationController
  def index
    @stories = Story.all.order(id: :desc).page params[:page]
  end

  def show
    @story = Story.find(params[:id])
    begin
      @parsed_story = JSON.parse(@story.stem) if @story.stem
    rescue JSON::ParserError
      false
    end
  end

end
