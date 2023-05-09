class Images::ImagineImageJob < ApplicationJob
  queue_as :default

  def perform(image:)

    # check if the card imagination exists
    if image.card_imagination.blank?
      imagination = Imagination.create(image:, aspect_ratio: :card, status: :pending, message_uuid: SecureRandom.uuid)
      prompt = "#{image.idea} --ar 2:1"

      begin
        payload = NextLeg.imagine(prompt:, ref: imagination.message_uuid)
        imagination.update(payload:)
      rescue StandardError => _e
        image.update(invalid_prompt: true)
      end

      throttle_requests
    end

    if image.landscape_imagination.blank?
      imagination = Imagination.create(image:, aspect_ratio: :landscape, status: :pending, message_uuid: SecureRandom.uuid)
      prompt = "#{image.idea} --ar 176:100"

      begin
        payload = NextLeg.imagine(prompt:, ref: imagination.message_uuid)
        imagination.update(payload:)
      rescue StandardError => _e
        image.update(invalid_prompt: true)
      end

      throttle_requests
    end

    if image.portrait_imagination.blank?
      imagination = Imagination.create(image:, aspect_ratio: :portrait, status: :pending, message_uuid: SecureRandom.uuid)
      prompt = "#{image.idea} --ar 57:100"

      begin
        payload = NextLeg.imagine(prompt:, ref: imagination.message_uuid)
        imagination.update(payload:)
      rescue StandardError => _e
        image.update(invalid_prompt: true)
      end
    end

    image.update(processed: true)
  end

  def throttle_requests
    pending_imaginations = Imagination.where(status: :pending).count

    if pending_imaginations > 3
      sleep(300)
    elsif pending_imaginations > 2
      sleep(180)
    else
      sleep(120)
    end
  end
end
