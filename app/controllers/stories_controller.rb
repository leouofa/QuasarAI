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

  def approve
    @story = Story.find(params[:id])
    @story.update(approved: true)
    redirect_to story_path(@story)
  end

  def disapprove
    @story = Story.find(params[:id])
    @story.update(approved: false)
    redirect_to story_path(@story)
  end

  private

  def set_scope
    if params[:scope] && params[:scope] == 'pending'
      return 'needs_approval'
    elsif params[:scope] && params[:scope] == 'approved'
      return 'approved_stories'
    elsif params[:scope] && params[:scope] == 'denied'
      return 'denied_stories'
    elsif params[:scope] && params[:scope] == 'published'
      return 'published_stories'
    end

    'viewable'
  end
end
