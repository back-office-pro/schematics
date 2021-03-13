require 'rails_helper'
require 'rspec_api_documentation/dsl'

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
    end
  end
end
