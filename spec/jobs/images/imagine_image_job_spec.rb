require 'rails_helper'

RSpec.describe Images::ImagineImageJob, type: :job do
  let(:image) { create(:image) } # Assuming you have a factory for the Image model
  let(:prompts) { 'test_prompts' }
  let(:prompt_extra) { 'test_prompt_extra' }
  let(:card_ratio) { '2:1' }
  let(:landscape_ratio) { '176:100' }
  let(:portrait_ratio) { '57:100' }

  before do
    allow_any_instance_of(Images::ImagineImageJob).to receive(:s).and_return(prompt_extra)
    allow(NextLeg).to receive(:imagine).and_return({})
    allow_any_instance_of(Images::ImagineImageJob).to receive(:throttle_requests)
  end

  describe '#perform' do
    it 'creates imaginations for card, landscape, and portrait aspect ratios if they are blank' do
      expect {
        described_class.perform_now(image: image)
      }.to change { Imagination.count }.by(3)

      expect(Imagination.where(image: image, aspect_ratio: :card).count).to eq(1)
      expect(Imagination.where(image: image, aspect_ratio: :landscape).count).to eq(1)
      expect(Imagination.where(image: image, aspect_ratio: :portrait).count).to eq(1)
    end

    it 'updates the image as processed' do
      expect {
        described_class.perform_now(image: image)
      }.to change { image.reload.processed }.from(false).to(true)
    end
  end

  describe '#create_imagination' do
    let(:aspect_ratio) { :card }
    let(:ratio_value) { card_ratio }
    let(:message_uuid) { SecureRandom.uuid }

    before do
      allow(SecureRandom).to receive(:uuid).and_return(message_uuid)
    end

    it 'creates an imagination with the correct attributes and calls NextLeg.imagine' do
      expect {
        subject.create_imagination(image, prompt_extra, aspect_ratio, ratio_value)
      }.to change { Imagination.count }.by(1)

      imagination = Imagination.last
      expect(imagination.image).to eq(image)
      expect(imagination.aspect_ratio).to eq(aspect_ratio.to_s)
      expect(imagination.status).to eq('pending')
      expect(imagination.message_uuid).to eq(message_uuid)

      prompt = "#{image.idea} #{prompt_extra} --ar #{ratio_value}"
      expect(NextLeg).to have_received(:imagine).with(prompt: prompt, ref: message_uuid)
    end
  end
end
