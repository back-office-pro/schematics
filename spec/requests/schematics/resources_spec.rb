# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Resources' do
  include Schematics::ResourcesHelper

  include_context 'with authenticated user'
  include_context 'with admin role'

  let(:role) { admin_role }
  let(:first_api_key) do
    Demo::APIKey.create!(
      name: 'First key',
      expires_at: Time.current.yesterday,
      permissions:
    )
  end
  let(:second_api_key) do
    Demo::APIKey.create!(
      name: 'Second key',
      expires_at: Time.current.tomorrow,
      permissions:
    )
  end

  before { [first_api_key, second_api_key] }

  describe 'GET #api_keys' do
    let(:do_request) { get(resources_path(Demo::APIKey), params:, headers:) }

    before { do_request }

    context 'when searching first api key' do
      let(:params) { { filter: { name: 'first' } } }
      let(:expected_response) { a_hash_including('id' => first_api_key.id) }

      it { is_expected.to have_http_status(:success) }
      its(:parsed_body) { is_expected.to contain_exactly(expected_response) }
    end

    context 'when searching second api key' do
      let(:params) { { filter: { name: 'second' } } }
      let(:expected_response) { a_hash_including('id' => second_api_key.id) }

      it { is_expected.to have_http_status(:success) }
      its(:parsed_body) { is_expected.to contain_exactly(expected_response) }
    end

    context 'when searching active api key' do
      let(:params) { { filter: { active: true } } }
      let(:expected_response) { a_hash_including('id' => second_api_key.id) }

      it { is_expected.to have_http_status(:success) }
      its(:parsed_body) { is_expected.to contain_exactly(expected_response) }
    end

    context 'when searching not active api key' do
      let(:params) { { filter: { active: false } } }
      let(:expected_response) { a_hash_including('id' => first_api_key.id) }

      it { is_expected.to have_http_status(:success) }
      its(:parsed_body) { is_expected.to contain_exactly(expected_response) }
    end

    context 'when searching for not expired api key' do
      let(:params) { { filter: { expires_at: { gte: Time.current } } } }
      let(:expected_response) { a_hash_including('id' => second_api_key.id) }

      it { is_expected.to have_http_status(:success) }
      its(:parsed_body) { is_expected.to contain_exactly(expected_response) }
    end

    context 'when searching for expired api key' do
      let(:params) { { filter: { expires_at: { lte: Time.current } } } }
      let(:expected_response) { a_hash_including('id' => first_api_key.id) }

      it { is_expected.to have_http_status(:success) }
      its(:parsed_body) { is_expected.to contain_exactly(expected_response) }
    end
  end
end
