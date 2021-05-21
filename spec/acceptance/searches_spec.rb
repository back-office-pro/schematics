require 'rails_helper'
require 'rspec_api_documentation/dsl'
require 'schematics/specs/helpers'

resource 'Searches' do
  extend Schematics::Specs::Helpers

  shared_setup
  token_auth

  get '/searches/:query' do
    with_options with_example: true do
      parameter :query, 'The query string', required: true
    end

    let(:query) { 'admin' }

    example 'Success' do
      do_request
      expect(response_status).to eq(200)
      expect(json_response).to be_empty
    end
  end
end
