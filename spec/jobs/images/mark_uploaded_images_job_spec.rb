require 'rails_helper'

RSpec.describe Images::MarkUploadedImagesJob, type: :job do
  include ActiveJob::TestHelper

  subject(:job) { described_class.perform_later }

  it 'queues the job' do
    expect { job }
      .to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
    expect(described_class).to have_been_enqueued.on_queue('default')
  end

  describe '#perform' do
    let!(:image1) { create(:image, uploaded: false) }
    let!(:image2) { create(:image, uploaded: false) }
    let!(:image3) { create(:image, uploaded: false) }

    before do
      # assuming unuploaded_with_three_uploaded_imaginations only returns images with 3 uploaded imaginations
      allow(Image).to receive(:unuploaded_with_three_uploaded_imaginations).and_return([image1, image2, image3])
    end

    it 'marks images as uploaded' do
      perform_enqueued_jobs { job }

      [image1, image2, image3].each do |image|
        expect(image.reload.uploaded).to be true
      end
    end
  end
end
