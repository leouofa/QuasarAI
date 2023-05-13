require 'rails_helper'

RSpec.describe Webhooks::MidjourneyController, type: :controller do
  describe '#create' do
    let(:imagination) { create(:imagination) }
    let(:params) do
      {
        'ref' => imagination.message_uuid,
        'midjourney' => 'some_payload',
        'buttonMessageId' => 'some_id'
      }
    end

    context 'when imagination is pending' do
      before do
        imagination.update(status: 'pending')
        allow(NextLeg).to receive(:press_button)
      end

      it 'presses button and changes status to upscaling' do
        post :create, params: params

        expect(NextLeg).to have_received(:press_button)
        expect(imagination.reload.status).to eq('upscaling')
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when imagination is upscaling' do
      before { imagination.update(status: 'upscaling') }

      it 'changes status to success' do
        post :create, params: params

        expect(imagination.reload.status).to eq('success')
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when ref parameter is missing' do
      it 'returns unprocessable entity' do
        post :create, params: params.except('ref')

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
