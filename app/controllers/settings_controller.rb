class SettingsController < ApplicationController
  def index
    @settings = Setting.instance
  end

  def edit
    @settings = Setting.instance
  end

  def update
    return unless current_user.admin?

    @settings = Setting.instance
    if @settings.update(settings_params)
      redirect_to settings_path, notice: 'Settings were successfully updated.'
    else
      render :edit
    end
  end

  private

  def settings_params
    params.require(:setting).permit(:topics, :prompts, :tunings)
  end
end
