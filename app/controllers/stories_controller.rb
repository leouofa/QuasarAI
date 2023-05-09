class StoriesController < ApplicationController
  include RestrictedAccess
  def index
    @stories = Story.all.order(id: :desc).page params[:page]
    @total_stories = Story.all.count
  end

  def show
    @story = Story.find(params[:id])
    begin
      @parsed_story = JSON.parse(@story.stem) if @story.stem
    rescue JSON::ParserError
      false
    end
    @images = Image.where(story: @story, invalid_prompt: false)
  end

end
