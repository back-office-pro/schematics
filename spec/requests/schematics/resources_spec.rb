# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Resources' do
  include_context 'with authenticated user'

  let(:role) { admin_role }
  let(:first_api_key) { ApiKey.create!(name: 'First key', expires_at: Time.current.yesterday) }
  let(:second_api_key) { ApiKey.create!(name: 'Second key', expires_at: Time.current.tomorrow) }

  before { [first_api_key, second_api_key] }

  [SearchEngine::Postgresql.new, SearchEngine::Elasticsearch.new].each do |search_engine|
    describe 'GET #api_keys' do
      let(:do_request) { get(api_keys_path, params:, headers:) }

      before do
        allow(Tenant).to receive(:search_engine).and_return(search_engine)
        ApiKey.include(search_engine.concern)
        ApiKey.try(:reindex)
        do_request
      end

      context 'when searching first api key' do
        let(:params) { { filter: { name: 'first' } } }
        let(:expected_response) { a_hash_including('id' => first_api_key.id) }

        it { is_expected.to have_http_status(:success) }
        it { expect(json_response).to contain_exactly(expected_response) }
      end

      context 'when searching second api key' do
        let(:params) { { filter: { name: 'second' } } }
        let(:expected_response) { a_hash_including('id' => second_api_key.id) }

        it { is_expected.to have_http_status(:success) }
        it { expect(json_response).to contain_exactly(expected_response) }
      end

      context 'when searching active api key' do
        let(:params) { { filter: { active: true } } }
        let(:expected_response) { a_hash_including('id' => second_api_key.id) }

        it { is_expected.to have_http_status(:success) }
        it { expect(json_response).to contain_exactly(expected_response) }
      end

      context 'when searching not active api key' do
        let(:params) { { filter: { active: false } } }
        let(:expected_response) { a_hash_including('id' => first_api_key.id) }

        it { is_expected.to have_http_status(:success) }
        it { expect(json_response).to contain_exactly(expected_response) }
      end

      context 'when searching for not expired api key' do
        let(:params) { { filter: { expires_at: { gte: Time.current } } } }
        let(:expected_response) { a_hash_including('id' => second_api_key.id) }

        it { is_expected.to have_http_status(:success) }
        it { expect(json_response).to contain_exactly(expected_response) }
      end

      context 'when searching for expired api key' do
        let(:params) { { filter: { expires_at: { lte: Time.current } } } }
        let(:expected_response) { a_hash_including('id' => first_api_key.id) }

        it { is_expected.to have_http_status(:success) }
        it { expect(json_response).to contain_exactly(expected_response) }
      end
    end
  end
end
