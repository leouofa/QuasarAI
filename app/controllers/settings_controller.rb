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

    # We are doing this here instead of doing this in the model to avoid
    # dealing with the fact that rails stores this value as time, meaning it will add
    # the full date which makes format validation way harder.
    start_time = settings_params[:publish_start_time]
    end_time = settings_params[:publish_end_time]

    if !valid_time_format?(start_time) || !valid_time_format?(end_time)
      @settings.errors.add(:base, 'Both `start` and `end` time should be HH:MM format.')
      render :edit
      return
    end

    if @settings.update(settings_params)
      UpdateSettingsJob.perform_now

      redirect_to settings_path, notice: 'Settings were successfully updated.'
    else
      render :edit
    end
  end

  private

  def settings_params
    params.require(:setting).permit(:topics, :prompts, :tunings, :pillars, :publish_start_time, :publish_end_time)
  end

  def valid_time_format?(time)
    time_format = /\A([01]\d|2[0-3]):([0-5]\d)\z/
    time_format.match?(time)
  end
end
