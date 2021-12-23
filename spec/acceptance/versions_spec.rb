# frozen_string_literal: true

require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Versions' do
  extend Schematics::Specs::Helpers

  shared_setup
  token_auth

  get '/versions' do
    with_options with_example: true do
      parameter :items, 'Items per page'
    end

    example 'Success' do
      do_request
      expect(response_status).to eq(200)
      expect(json_response).to be_empty
    end
  end

  get '/versions/:id' do
    context 'when version does not exist' do
      example 'Not found' do
        do_request
        expect(response_status).to eq(404)
        expect(response_body).to be_blank
      end
    end

    context 'when version exists' do
      let(:id) { version.id }
      let(:version) { Schematics::Version.create!(event: 'create', item: user, user:) }
      let(:expected_reponse) do
        {
          'item_type' => 'User',
          'event' => 'create',
          'item_id' => user.id,
          'whodunnit' => user.id
        }
      end

      example 'Success' do
        do_request
        expect(response_status).to eq(200)
        expect(json_response).to match(hash_including(expected_reponse))
      end
    end
  end

  patch '/versions/:id/revert' do
    context 'when version does not exist' do
      example 'Not found' do
        do_request
        expect(response_status).to eq(404)
        expect(response_body).to be_blank
      end
    end

    context 'when version exists' do
      let(:id) { version.id }
      let(:version) { Schematics::Version.create!(event: 'create', item: user, user:) }

      example 'No content' do
        do_request
        expect(response_status).to eq(204)
        expect(response_body).to be_blank
      end
    end
  end
end
