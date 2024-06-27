require 'rails_helper'

RSpec.describe Articles::CreateArticlesJob, type: :job do
  let(:pillar) { create(:pillar, title: "Sample Title") }
  let(:pillar_column) { create(:pillar_column, pillar:, name: "Column Name", description: "Column Description") }
  let(:client) { instance_double('OpenAI::Client') }
  let(:article_class) { class_double('Article').as_stubbed_const }

  before do
    allow(OpenAI::Client).to receive(:new).and_return(client)

    allow(client).to receive(:chat).and_return({
                                                 'choices' => [
                                                   { 'message' => { 'content' => '{"title": "Article Title", "summary": "Article Summary", "content": []}' } }
                                                 ]
                                               })
  end

  context 'when the response is valid JSON' do
    before do
      allow(client).to receive(:chat).and_return({
                                                   'choices' => [
                                                     { 'message' => { 'content' => '{"title": "Article Title", "summary": "Article Summary", "content": []}' } }
                                                   ]
                                                 })
    end
  end

  context 'when the response is not valid JSON' do
    before do
      allow(client).to receive(:chat).and_return({
                                                   'choices' => [
                                                     { 'message' => { 'content' => 'not valid json' } }
                                                   ]
                                                 })
    end

    it 'does not create an article' do
      expect(article_class).not_to receive(:create)

      described_class.perform_now(pillar_column:)
    end
  end

  context 'when the response contains an error' do
    before do
      allow(client).to receive(:chat).and_return({
                                                   'error' => 'error message'
                                                 })
    end

    it 'does not create an article' do
      expect(article_class).not_to receive(:create)

      described_class.perform_now(pillar_column:)
    end
  end
end
