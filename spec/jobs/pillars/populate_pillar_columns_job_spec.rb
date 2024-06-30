require 'rails_helper'

RSpec.describe Pillars::PopulatePillarColumnsJob, type: :job do
  let(:pillar) { create(:pillar) }
  let(:client) { instance_double('OpenAI::Client') }
  let(:pillar_column_class) { class_double('PillarColumn').as_stubbed_const }
  let(:pillar_columns_relation) { instance_double(ActiveRecord::Relation) }

  before do
    allow(OpenAI::Client).to receive(:new).and_return(client)

    allow(client).to receive(:chat)
      .and_return({
                    'choices' => [
                      { 'message' =>
                          { 'content' => '{"topics":[{"title":"Topic 1","description":"Description 1"}]}' } }
                    ]
                  })

    allow(pillar_column_class).to receive(:where).and_return(pillar_columns_relation)
    allow(pillar_columns_relation).to receive(:count).and_return(0)
    allow(pillar_column_class).to receive(:exists?).and_return(false)
  end

  context 'when the response is valid JSON' do
    before do
      allow(client).to receive(:chat)
        .and_return({
                      'choices' => [
                        { 'message' =>
                            { 'content' => '{"topics":[{"title":"Topic 1","description":"Description 1"}]}' } }
                      ]
                    })
    end

    it 'creates a PillarColumn with the response content' do
      expect(pillar_column_class).to receive(:create!).with(
        pillar_id: pillar.id,
        name: 'Topic 1',
        description: 'Description 1'
      )

      described_class.perform_now(pillar:)
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

    it 'does not create any PillarColumns' do
      expect(pillar_column_class).not_to receive(:create!)

      described_class.perform_now(pillar:)
    end
  end

  context 'when the response contains an error' do
    before do
      allow(client).to receive(:chat).and_return({
                                                   'error' => 'error message'
                                                 })
    end

    it 'does not create any PillarColumns' do
      expect(pillar_column_class).not_to receive(:create!)

      described_class.perform_now(pillar:)
    end
  end
end
