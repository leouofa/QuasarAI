class TweetsController < ApplicationController
  include RestrictedAccess
  def index
    scope = set_scope

    @tweets = Tweet.send(scope).order(id: :desc).page params[:page]
    @total_tweets = Tweet.send(scope).count
  end

  def show
    @tweet = Tweet.find(params[:id])
  end

  def edit
    @tweet = Tweet.find(params[:id])
    @tweet_text = JSON.parse(@tweet.stem)["tweet"]
  end

  def update
    @tweet = Tweet.find(params[:id])
    # Parse the JSON stored in the stem attribute
    stem_json = JSON.parse(@tweet.stem)

    # Update the "tweet" value in the parsed JSON object
    stem_json["tweet"] = params[:tweet][:stem]

    # Convert the JSON object back to a string and save it to the tweet's stem attribute
    @tweet.stem = stem_json.to_json

    # Turn off invalid JSON since its now valid
    @tweet.invalid_json = false

    # Save the tweet
    if @tweet.save
      redirect_to tweet_path(@tweet), notice: 'Tweet was successfully updated.'
    else
      render :edit
    end
  end

  def approve
    @tweet = Tweet.find(params[:id])
    @tweet.update(approved: true)
    redirect_to tweet_path(@tweet)
  end

  def disapprove
    @tweet = Tweet.find(params[:id])
    @tweet.update(approved: false)
    redirect_to tweet_path(@tweet)
  end

  private

  def set_scope
    if params[:scope] && params[:scope] == 'pending'
      return 'needs_approval'
    elsif params[:scope] && params[:scope] == 'approved'
      return 'approved_tweets'
    elsif params[:scope] && params[:scope] == 'denied'
      return 'denied'
    elsif params[:scope] && params[:scope] == 'published'
      return 'published'
    end

    'all'
  end
end
