require 'rails_helper'

RSpec.describe Tweets::MakeStemJob, type: :job do
  let(:discussion) { create(:discussion) } # assuming you have a factory for discussion
  let(:story) { discussion.story }
  let(:sub_topic) { story.sub_topic }
  let(:tag) { story.tag }

  before do
    allow(OpenAI::Client).to receive(:new).and_return(double.as_null_object)
  end

  describe '#perform_later' do
    it 'enqueues the job' do
      ActiveJob::Base.queue_adapter = :test
      expect do
        Tweets::MakeStemJob.perform_later(discussion:)
      end.to have_enqueued_job
    end
  end

  describe '#perform' do
    subject(:job) { described_class.new.perform(discussion:) }

    context 'when the discussion does not have a tweet' do
      before do
        allow(discussion).to receive(:tweet).and_return(nil)
      end

      it 'creates a new tweet' do
        expect(Tweet).to receive(:create)
        job
      end

      context 'when the JSON is valid' do
        before do
          allow_any_instance_of(Tweets::MakeStemJob).to receive(:valid_json?).and_return(true)
          allow_any_instance_of(Tweets::MakeStemJob).to receive(:chat).and_return({ "choices" => [{ "message" => { "content" => "{}" } }] })
        end

        it 'creates a tweet with a valid stem' do
          expect(Tweet).to receive(:create).with(hash_including(stem: "{}"))
          job
        end
      end

      context 'when the JSON is invalid' do
        before do
          allow_any_instance_of(Tweets::MakeStemJob).to receive(:valid_json?).and_return(false)
          allow_any_instance_of(Tweets::MakeStemJob).to receive(:chat).and_return({ "error" => "invalid" })
        end

        it 'creates a tweet with invalid_json set to true' do
          expect(Tweet).to receive(:create).with(hash_including(invalid_json: true))
          job
        end
      end
    end
  end
end
