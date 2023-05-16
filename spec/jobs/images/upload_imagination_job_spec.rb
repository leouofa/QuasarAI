require 'rails_helper'

RSpec.describe Images::UploadImaginationsJob, type: :job do
  describe '#perform' do
    let(:successful_unuploaded_imagination) { instance_double('Imagination') }

    before do
      allow(Imagination).to receive(:successful_unuploaded).and_return([successful_unuploaded_imagination])
      allow(successful_unuploaded_imagination).to receive(:payload).and_return({ 'imageUrl' => 'http://example.com/image.jpg' })
      allow(successful_unuploaded_imagination).to receive(:update!)
    end

    it 'uploads an image and updates the imagination' do
      uploadcare_response = instance_double('UploadcareResponse')
      allow(Uploadcare::UploadApi).to receive(:upload_file).and_return(uploadcare_response)

      described_class.perform_now

      expect(Uploadcare::UploadApi).to have_received(:upload_file).with('http://example.com/image.jpg', { store: true })
      expect(successful_unuploaded_imagination).to have_received(:update!).with(uploadcare: uploadcare_response,
                                                                                uploaded: true)
    end
  end
end
