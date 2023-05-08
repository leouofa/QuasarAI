class Webhooks::MidjourneyController < ApplicationController
  skip_forgery_protection

  def index
    byebug
  end

  def create
    return head :unprocessable_entity unless params['ref'].present?

    imagination = Imagination.find_by_message_uuid params['ref']
    return head :unprocessable_entity unless imagination.present?

    if imagination.status == 'pending'
      button_message_id = params["buttonMessageId"]
      _button_response = NextLeg.press_button button: "U#{rand(1..4)}",
                                              ref: imagination.message_uuid,
                                              button_message_id: button_message_id

      imagination.update(payload: params['midjourney'], status: :upscaling)
      return head :ok
    end

    if imagination.status == 'upscaling'
      imagination.update(payload: params['midjourney'], status: :success)
      head :ok
    end
  end
end
