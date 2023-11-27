# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WebhookEndpoint do
  include Schematics::Specs::Model

  describe '#request' do
    subject(:request) { record.request(body) }

    let(:body) { { 'event' => 'user.update', 'payload' => {} } }

    before { stub_request(:get, record.url).to_return(status: 200) }

    it { is_expected.to be_a(Net::HTTPOK) }
  end
end
