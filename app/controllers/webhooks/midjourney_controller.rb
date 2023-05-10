module Webhooks
  class MidjourneyController < ApplicationController
    skip_forgery_protection

    def create
      return head :unprocessable_entity if params['ref'].blank?

      imagination = Imagination.find_by message_uuid: params['ref']
      return head :unprocessable_entity if imagination.blank?

      if imagination.status == 'pending'
        button_message_id = params["buttonMessageId"]
        _button_response = NextLeg.press_button(button: "U#{rand(1..4)}",
                                                ref: imagination.message_uuid,
                                                button_message_id:)

        imagination.update(payload: params['midjourney'], status: :upscaling)
        return head :ok
      end

      return unless imagination.status == 'upscaling'

      imagination.update(payload: params['midjourney'], status: :success)
      head :ok
    end
  end
end
