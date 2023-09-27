# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Resources' do
  include_context 'with authenticated user'
  include_context 'with admin role'

  let(:role) { admin_role }
  let(:first_api_key) do
    ApiKey.create!(
      name: 'First key',
      expires_at: Time.current.yesterday,
      permissions:
    )
  end
  let(:second_api_key) do
    ApiKey.create!(
      name: 'Second key',
      expires_at: Time.current.tomorrow,
      permissions:
    )
  end

  before { [first_api_key, second_api_key] }

  %w[postgresql opensearch].each do |search_engine_name|
    describe 'GET #api_keys' do
      let(:do_request) { get(api_keys_path, params:, headers:) }
      let(:search_engine) { SearchEngine.const_get(search_engine_name.camelize).new }

      before do
        allow(Tenant).to receive(:search_engine).and_return(search_engine)
        ApiKey.include(search_engine.concern)
        ApiKey.try(:reindex)
        do_request
      end

      after { ApiKey.reload_definitions! }

      context "when searching first api key with #{search_engine_name}" do
        let(:params) { { filter: { name: 'first' } } }
        let(:expected_response) { a_hash_including('id' => first_api_key.id) }

        it { is_expected.to have_http_status(:success) }
        it { expect(json_response).to contain_exactly(expected_response) }
      end

      context "when searching second api key with #{search_engine_name}" do
        let(:params) { { filter: { name: 'second' } } }
        let(:expected_response) { a_hash_including('id' => second_api_key.id) }

        it { is_expected.to have_http_status(:success) }
        it { expect(json_response).to contain_exactly(expected_response) }
      end

      context "when searching active api key with #{search_engine_name}" do
        let(:params) { { filter: { active: true } } }
        let(:expected_response) { a_hash_including('id' => second_api_key.id) }

        it { is_expected.to have_http_status(:success) }
        it { expect(json_response).to contain_exactly(expected_response) }
      end

      context "when searching not active api key with #{search_engine_name}" do
        let(:params) { { filter: { active: false } } }
        let(:expected_response) { a_hash_including('id' => first_api_key.id) }

        it { is_expected.to have_http_status(:success) }
        it { expect(json_response).to contain_exactly(expected_response) }
      end

      context "when searching for not expired api key with #{search_engine_name}" do
        let(:params) { { filter: { expires_at: { gte: Time.current } } } }
        let(:expected_response) { a_hash_including('id' => second_api_key.id) }

        it { is_expected.to have_http_status(:success) }
        it { expect(json_response).to contain_exactly(expected_response) }
      end

      context "when searching for expired api key with #{search_engine_name}" do
        let(:params) { { filter: { expires_at: { lte: Time.current } } } }
        let(:expected_response) { a_hash_including('id' => first_api_key.id) }

        it { is_expected.to have_http_status(:success) }
        it { expect(json_response).to contain_exactly(expected_response) }
      end
    end
  end
end
