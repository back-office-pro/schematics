require 'acceptance_helper'

resource 'Searches' do
  shared_setup
  token_auth

  get '/searches/:query' do
    with_options with_example: true do
      parameter :query, 'The query string', required: true
    end

    let(:query) { 'admin' }

    example_request 'search for admin' do
      expect(response_status).to eq(200)
    end
  end
end
