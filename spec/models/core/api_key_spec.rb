# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Demo::APIKey do
  include Schematics::Specs::Model

  its(:login!) { is_expected.to eq(record) }
  its(:user) { is_expected.to be_a(Schematics::Guest::User) }

  describe '#touch!' do
    subject { record.touch!(request, response, response_time) }

    let(:request) { ActionController::TestRequest.create({}) }
    let(:response) { ActionDispatch::TestResponse.create }
    let(:response_time) { 0.1 }

    before { request.path = '/api-keys' }

    it { is_expected.to be_a(APIRequest) }
    its(:api_key) { is_expected.to eq(record) }
    its(:ip) { is_expected.to eq('0.0.0.0') }
    its(:request_method) { is_expected.to eq('GET') }
    its(:endpoint) { is_expected.to eq('/api-keys') }
    its(:response_code) { is_expected.to eq(200) }
    its(:response_time) { is_expected.to eq(100) }
  end
end
