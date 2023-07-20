class StoriesController < ApplicationController
  include RestrictedAccess
  def index
    scope = set_scope

    @stories = Story.send(scope).order(id: :desc).page params[:page]
    @total_stories = Story.send(scope).count
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

  def set_scope
    if params[:scope] && params[:scope] == 'unpublished'
      return 'unpublished_stories'
    elsif params[:scope] && params[:scope] == 'published'
      return 'published_stories'
    end

    'viewable'
  end
end
