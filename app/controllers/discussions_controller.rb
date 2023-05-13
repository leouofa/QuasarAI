class DiscussionsController < ApplicationController
  include RestrictedAccess
  def index
    @discussions = Discussion.all.order(id: :desc).page params[:page]
    @total_discussions = Discussion.all.count
  end

  def show
    @discussion = Discussion.find(params[:id])
    begin
      @parsed_discussion = JSON.parse(@discussion.stem) if @discussion.stem
    rescue JSON::ParserError
      false
    end
    @images = Image.where(discussion: @discussion, invalid_prompt: false)
  end
end
