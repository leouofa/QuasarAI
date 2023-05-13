require 'rails_helper'

RSpec.describe Stories::MakeStemJob, type: :job do
  describe '#perform' do
    let(:story) { create(:story, processed: false) }
    let(:sub_topic) { create(:sub_topic) }
    let(:tag) { create(:tag) }
    let(:feed_items) { create_list(:feed_item, 5, feed: create(:feed, sub_topic: sub_topic)) }

    before do
      allow(OpenAI::Client).to receive(:new).and_return(double)
      story.sub_topic = sub_topic
      story.tag = tag
      story.feed_items = feed_items
      story.save!
    end

    context 'when story is already processed' do
      it 'does not process the story' do
        story.update!(processed: true)
        expect_any_instance_of(OpenAI::Client).not_to receive(:chat)
        described_class.perform_now(story: story)
      end
    end

    context 'when story is not processed' do
      let(:client) { instance_double(OpenAI::Client) }
      let(:response) do
        {
          "choices" => [
            {
              "message" => {
                "content" => '{"title": "title", "summary": "summary", "content": []}',
              }
            }
          ]
        }
      end

      before do
        allow(OpenAI::Client).to receive(:new).and_return(client)
        allow(client).to receive(:chat).and_return(response)
      end

      it 'processes the story' do
        described_class.perform_now(story: story)
        expect(story.reload.processed).to be(true)
        expect(story.stem).to eq(response["choices"][0]["message"]["content"])
      end

      context 'when response contains invalid json' do
        let(:response) do
          {
            "choices" => [
              {
                "message" => {
                  "content" => 'invalid json',
                }
              }
            ]
          }
        end

        it 'marks the story as invalid_json' do
          described_class.perform_now(story: story)
          expect(story.reload.invalid_json).to be(true)
        end
      end

      context 'when an error occurs during processing' do
        let(:response) { { "error" => "some error" } }

        it 'marks the story as invalid_json' do
          allow(client).to receive(:chat).and_return(response)
          described_class.perform_now(story: story)
          expect(story.reload.invalid_json).to be(true)
        end
      end
    end
  end
end
