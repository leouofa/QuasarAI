class TweetsController < ApplicationController
  include RestrictedAccess
  def index
    @tweets = Tweet.all.order(id: :desc).page params[:page]
    @total_tweets = Tweet.all.count
  end
end
