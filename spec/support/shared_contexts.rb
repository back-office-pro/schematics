# frozen_string_literal: true

RSpec.shared_context 'with unauthenticated user' do
  include Schematics::Engine.routes.url_helpers

  subject { response }

  include_context 'with user'

  let(:json_response) { ::JSON.parse(response.body) }
  let(:headers) { { 'Accept' => 'application/json' } }
  let(:permissions) { ::Permission.create_all_entities_permissions! }
  let(:admin_role) { Role.create!(name: 'Admin', permissions:) }

  before do
    allow_any_instance_of(::Licence).to receive(:expires_on).and_return(1.day.from_now) # rubocop:disable RSpec/AnyInstance
    admin_role
    user
  end
end

RSpec.shared_context 'with authenticated user' do
  include_context 'with unauthenticated user'

  let(:session) { Session.create!(user:) }
  let(:auth_token) { ::JsonWebToken.encode(auth_token: session.auth_token) }
  let(:headers) { { 'Accept' => 'application/json', 'Authorization' => auth_token } }
end

RSpec.shared_context 'with import' do
  include_context 'with user'

  let(:import) { Import.create!(file:, author: user) }
  let(:model_class) { Role }
  let(:file) do
    ::ActiveStorage::Blob.create_and_upload!(
      io: File.open(file_fixture('roles.csv'), 'rb'),
      filename: 'roles.csv',
      content_type: ::Mime[:csv].to_s
    ).signed_id
  end
end

RSpec.shared_context 'with user' do
  let(:reset_password_sent_at) { nil }
  let(:role) { Role.create!(name: 'Manager') }
  let(:user_id) { user.id }
  let(:user) do
    User.create!(
      :user,
      email: 'john.doe@nowhere.com',
      password: 'Azerty1!',
      first_name: 'John',
      last_name: 'Doe',
      role:,
      reset_password_sent_at:
    )
  end
end
