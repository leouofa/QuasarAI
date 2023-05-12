require 'rails_helper'
require 'feedly'

RSpec.describe Feedly do
  before(:each) do
    Feedly.configure do |config|
      config.token = 'example_token'
    end
  end

  describe '.get_contents' do
    let(:stream_id) { 'example_stream_id' }

    it 'returns parsed JSON data' do
      response_body = [{ 'title' => 'Example article', 'url' => 'https://example.com/article' }]
      stub_request(:get, "https://cloud.feedly.com/v3/streams/contents?streamId=#{stream_id}")
        .with(headers: { 'Authorization' => 'Bearer example_token' })
        .to_return(status: 200, body: response_body.to_json, headers: {})

      contents = Feedly.get_contents(stream_id)
      expect(contents).to eq(response_body)
    end

    it 'raises an error if the API returns an error code' do
      stub_request(:get, "https://cloud.feedly.com/v3/streams/contents?streamId=#{stream_id}")
        .with(headers: { 'Authorization' => 'Bearer example_token' })
        .to_return(status: 401, body: '', headers: {})

      expect { Feedly.get_contents(stream_id) }.to raise_error(RuntimeError, 'Error: 401 - ')
    end
  end
end
