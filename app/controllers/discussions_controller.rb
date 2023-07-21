class DiscussionsController < ApplicationController
  include RestrictedAccess
  def index
    scope = set_scope

    @discussions = Discussion.send(scope).order(id: :desc).page params[:page]
    @total_discussions = Discussion.send(scope).count
  end

  def show
    @discussion = Discussion.find(params[:id])
    begin
      @parsed_discussion = JSON.parse(@discussion.stem) if @discussion.stem
    rescue JSON::ParserError
      false
    end
    @images = Image.where(story: @discussion.story, invalid_prompt: false)
  end

  private

  def set_scope
    if params[:scope] && params[:scope] == 'unpublished'
      return 'unpublished'
    elsif params[:scope] && params[:scope] == 'published'
      return 'published'
    end

    'all'
  end
end
