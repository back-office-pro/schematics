# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApiKey do
  include Schematics::Specs::Model

  its(:login!) { is_expected.to eq(record) }
  its(:user) { is_expected.to be_a(Schematics::Guest::User) }

  describe '#touch!' do
    subject { record.touch!(request) }

    let(:request) { ActionController::TestRequest.create({}) }

    before do
      request.path = '/api-keys'
      request.session[:response_time] = 0.1
    end

    it { is_expected.to be_a(ApiRequest) }
    its(:api_key) { is_expected.to eq(record) }
    its(:ip) { is_expected.to eq('0.0.0.0') }
    its(:request_method) { is_expected.to eq('GET') }
    its(:endpoint) { is_expected.to eq('/api-keys') }
    its(:response_time) { is_expected.to eq(100) }
  end
end
