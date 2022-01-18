# frozen_string_literal: true

RSpec.shared_context 'with unauthenticated user' do
  include Schematics::Engine.routes.url_helpers

  subject { response }

  fixtures :users
  fixtures :roles

  let(:json_response) { JSON.parse(response.body) }
  let(:user) { users(:two) }
  let(:email) { user.email }
  let(:headers) { { 'Accept' => 'application/json' } }
  let(:auth_token) { JsonWebToken.encode(auth_token: user.auth_token) }

  before { do_request }
end

RSpec.shared_context 'with authenticated user' do
  include_context 'with unauthenticated user'

  let(:headers) do
    {
      'Accept' => 'application/json',
      'Authorization' => auth_token
    }
  end
end
