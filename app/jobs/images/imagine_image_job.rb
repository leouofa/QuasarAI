class Images::ImagineImageJob < ApplicationJob
  queue_as :default

  def perform(image:)

    # check if the card imagination exists
    unless image.card_imagination.present?
      imagination = Imagination.create(image:, aspect_ratio: :card, status: :pending, message_uuid: SecureRandom.uuid)
      prompt = "#{image.idea} --ar 2:1"

      begin
        payload = NextLeg.imagine(prompt:, ref: imagination.message_uuid)
        imagination.update(payload:)
      rescue StandardError => _e
        image.update(invalid_prompt: true)
      end
    end


  end
end
