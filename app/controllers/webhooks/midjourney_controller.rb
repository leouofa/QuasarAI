module Webhooks
  class MidjourneyController < ApplicationController
    skip_forgery_protection

    before_action :load_imagination, only: :create

    def create
      return head :unprocessable_entity unless @imagination

      process_imagination
    end

    private

    def load_imagination
      @imagination = Imagination.find_by(message_uuid: params['ref'])
    end

    def process_imagination
      if params['midjourney'] && (params['midjourney']['content'] == 'QUEUE_FULL' ||
        params['midjourney']['description'] == "You have reached the maximum allowed number of concurrent jobs. Don't worry, this job will start as soon as another one finishes!")
        lock = Lock.find_or_create_by(name: 'QueueFull')
        lock.update(locked: true)
      end

      case @imagination.status
      when 'pending'
        handle_pending
      when 'upscaling'
        handle_upscaling
      end
    end

    def handle_pending
      button_message_id = params["buttonMessageId"]
      NextLeg.press_button(button: "U#{rand(1..4)}",
                           ref: @imagination.message_uuid,
                           button_message_id:)

      @imagination.update(payload: params['midjourney'], status: :upscaling)
      head :ok
    end

    def handle_upscaling
      @imagination.update(payload: params['midjourney'], status: :success)
      head :ok
    end
  end
end
