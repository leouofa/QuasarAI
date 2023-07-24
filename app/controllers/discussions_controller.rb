class DiscussionsController < ApplicationController
  include RestrictedAccess
  def index
    scope = set_scope
    sort_order = set_sortorder

    @discussions = Discussion.send(scope).order(sort_order).page params[:page]
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

    'valid_discussions'
  end

  def set_sortorder
    if params[:scope] && params[:scope] == 'unpublished'
      'id desc'
    elsif params[:scope] && params[:scope] == 'published'
      'published_at desc'
    end

    'id desc'
  end
end
