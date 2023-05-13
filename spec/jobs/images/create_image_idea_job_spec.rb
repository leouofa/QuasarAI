require 'rails_helper'

RSpec.describe Images::CreateImageIdeaJob, type: :job do
  include ActiveJob::TestHelper

  let(:story) { create(:story) }  # Assuming you have FactoryBot in place
  subject(:job) { described_class.perform_later(story:) }

  let(:mock_response) do
    {
      "choices" => [{
        "message" => {
          "content" => '{"images": [
            { "description": "image idea 1" },
            { "description": "image idea 2" },
            { "description": "image idea 3" }
          ]}'
        }
      }]
    }
  end

  before do
    ActiveJob::Base.queue_adapter = :test
    story.update(invalid_images: false)
    allow_any_instance_of(OpenAI::Client).to receive(:chat).and_return(mock_response)
  end

  it 'queues the job' do
    expect { job }
      .to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
  end

  it 'is put in the default queue' do
    expect(described_class.new.queue_name).to eq('default')
  end

  it 'executes perform' do
    perform_enqueued_jobs { job }
  end

  it 'creates image ideas for valid story' do
    expect { perform_enqueued_jobs { job } }.to change(Image, :count).by(3)
  end

  it 'does not create image ideas for invalid story' do
    story.update(invalid_images: true)
    expect { perform_enqueued_jobs { job } }.to_not change(Image, :count)
  end

  after do
    clear_enqueued_jobs
    clear_performed_jobs
  end
end
