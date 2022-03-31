# frozen_string_literal: true

RSpec.shared_context 'with unauthenticated user' do
  include Schematics::Engine.routes.url_helpers

  subject { response }

  fixtures :users, :roles

  let(:json_response) { ::JSON.parse(response.body) }
  let(:user) { users(:two) }
  let(:email) { user.email }
  let(:headers) { { 'Accept' => 'application/json' } }
  let(:auth_token) { ::JsonWebToken.encode(auth_token: user.auth_token) }
end

RSpec.shared_context 'with authenticated user' do
  let(:admin_role) do
    ::Role.create!(name: 'Admin', permissions: ::Permission.create_all_entities_permissions!)
  end

  before { admin_role }

  include_context 'with unauthenticated user'

  let(:headers) { { 'Accept' => 'application/json', 'Authorization' => auth_token } }
end

RSpec.shared_context 'with import' do
  fixtures :users

  let(:import) { ::Import.create!(file:, author:) }
  let(:author) { users(:one) }
  let(:model_class) { Role }
  let(:file) do
    ::ActiveStorage::Blob.create_and_upload!(
      io: File.open(file_fixture('roles.csv'), 'rb'),
      filename: 'roles.csv',
      content_type: ::Mime[:csv].to_s
    ).signed_id
  end
end
