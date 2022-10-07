# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Application::ApiKey::ActiveQuery do
  include_context 'with user'

  let(:first_api_key) { ApiKey.create!(name: 'First key') }
  let(:second_api_key) { ApiKey.create!(name: 'Second key', expires_at: Time.current.yesterday) }
  let(:third_api_key) { ApiKey.create!(name: 'Third key', expires_at: Time.current.tomorrow) }

  before { [first_api_key, second_api_key, third_api_key] }

  its(:call) { is_expected.to contain_exactly(first_api_key, third_api_key) }
end
