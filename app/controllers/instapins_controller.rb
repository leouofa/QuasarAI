class InstapinsController < ApplicationController
  include RestrictedAccess
  def index
    scope = set_scope

    @instapins = Instapin.send(scope).order(id: :desc).page params[:page]
    @total_instapins = Instapin.send(scope).count
  end

  def show
    @instapin = Instapin.find(params[:id])
  end

  def edit
    @instapin = Instapin.find(params[:id])
    @instapin_text = JSON.parse(@instapin.stem)["post"]
  end

  def update
    @instapin = Instapin.find(params[:id])
    # Parse the JSON stored in the stem attribute
    stem_json = JSON.parse(@instapin.stem)

    # Update the "instapin" value in the parsed JSON object
    stem_json["post"] = params[:instapin][:stem]

    # Convert the JSON object back to a string and save it to the instapin's stem attribute
    @instapin.stem = stem_json.to_json

    # Turn off invalid JSON since its now valid
    @instapin.invalid_json = false

    # Save the InstaPin
    if @instapin.save
      redirect_to instapin_path(@instapin), notice: 'InstaPin was successfully updated.'
    else
      render :edit
    end
  end

  def approve
    @instapin = Instapin.find(params[:id])
    @instapin.update(approved: true)
    redirect_to instapin_path(@instapin)
  end

  def disapprove
    @instapin = Instapin.find(params[:id])
    @instapin.update(approved: false)
    redirect_to instapin_path(@instapin)
  end

  private

  def set_scope
    if params[:scope] && params[:scope] == 'pending'
      return 'needs_approval'
    elsif params[:scope] && params[:scope] == 'approved'
      return 'approved_instapins'
    elsif params[:scope] && params[:scope] == 'denied'
      return 'denied'
    elsif params[:scope] && params[:scope] == 'published'
      return 'published'
    end

    'all'
  end
end
