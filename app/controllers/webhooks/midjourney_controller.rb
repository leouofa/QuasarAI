module Webhooks
  class MidjourneyController < ApplicationController
    skip_forgery_protection

    UPSCALING_MAX_DELAY = 10
    UPSCALING_MIN_DELAY = 1

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

      handle_pending
    end

    def handle_pending
      sleep(rand(UPSCALING_MIN_DELAY..UPSCALING_MAX_DELAY))

      result = NextLeg.upscale(button: "U#{rand(1..4)}", button_message_id: params["buttonMessageId"])
      status = result["url"].present? ? :success : :failure
      @imagination.update(payload: params['midjourney'], status: status, upscaled_image_url: result["url"])
      head :ok
    end
  end
end
