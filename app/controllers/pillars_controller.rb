class PillarsController < ApplicationController
  include RestrictedAccess

  def index
    @pillars = Pillar.includes(:pillar_columns).order(id: :desc).page params[:page]
    @total_pillars = Pillar.count
  end
end
