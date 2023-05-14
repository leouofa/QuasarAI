require 'rails_helper'

RSpec.describe Images::ImagineImagesJob, type: :job do
  include ActiveJob::TestHelper

  subject(:job) { described_class.perform_later }

  it 'queues the job' do
    expect { job }
      .to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
  end

  context 'when the lock is not taken' do
    before do
      allow(Lock).to receive(:find_or_create_by).and_return(double(locked?: false, update: true))
    end

    it 'executes perform' do
      expect_any_instance_of(Images::ImagineImagesJob).to receive(:perform)
      perform_enqueued_jobs { job }
    end
  end

  context 'when the lock is taken' do
    before do
      allow(Lock).to receive(:find_or_create_by).and_return(double(locked?: true, update: true))
    end

    it 'does not execute perform' do
      expect(Image).not_to receive(:to_process)
      perform_enqueued_jobs { job }
    end
  end

  after do
    clear_enqueued_jobs
    clear_performed_jobs
  end
end
