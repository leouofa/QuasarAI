class PillarsController < ApplicationController
  include RestrictedAccess

  def index
    @pillars = Pillar.order(id: :desc).page params[:page]
    @total_pillars = Pillar.count
  end
end
