require 'rails_helper'

RSpec.describe Discussions::MakeStemJob, type: :job do
  # let(:story) { double('Story') }
  let(:story) { create(:story) }
  let(:sub_topic) { double('SubTopic', prompts: 'default', name: 'sub_topic_name') }
  let(:tag) { double('Tag', name: 'tag_name') }
  let(:discussion) { nil }
  let(:client) { instance_double('OpenAI::Client') }
  let(:discussion_class) { class_double('Discussion').as_stubbed_const }

  before do
    allow(story).to receive(:sub_topic).and_return(sub_topic)
    allow(story).to receive(:tag).and_return(tag)
    allow(story).to receive(:discussion).and_return(discussion)
    allow(story).to receive(:stem).and_return('stem')

    allow(OpenAI::Client).to receive(:new).and_return(client)

    allow(client).to receive(:chat).and_return({
                                                 'choices' => [
                                                   {'message' => {'content' => '{}' }}
                                                 ]
                                               })
  end

  it 'calls the OpenAI client with the correct parameters' do
    expect(client).to receive(:chat).with(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: anything,
        temperature: 0.7
      }
    )

    described_class.perform_now(story: story)
  end

  context 'when the response is valid JSON' do
    before do
      allow(client).to receive(:chat).and_return({
                                                   'choices' => [
                                                     {'message' => {'content' => '{}' }}
                                                   ]
                                                 })
    end

    it 'creates a discussion with the response content' do
      expect(discussion_class).to receive(:create).with(
        story: story,
        stem: '{}',
        processed: true,
        invalid_json: false
      )

      described_class.perform_now(story: story)
    end
  end

  context 'when the response is not valid JSON' do
    before do
      allow(client).to receive(:chat).and_return({
                                                   'choices' => [
                                                     {'message' => {'content' => 'not valid json' }}
                                                   ]
                                                 })
    end

    it 'creates a discussion with invalid_json set to true' do
      expect(discussion_class).to receive(:create).with(
        story: story,
        stem: 'not valid json',
        processed: true,
        invalid_json: true
      )

      described_class.perform_now(story: story)
    end
  end

  context 'when the response contains an error' do
    before do
      allow(client).to receive(:chat).and_return({
                                                   'error' => 'error message'
                                                 })
    end

    it 'creates a discussion with invalid_json set to true' do
      expect(discussion_class).to receive(:create).with(
        story: story,
        processed: true,
        invalid_json: true
      )

      described_class.perform_now(story: story)
    end
  end
end
