# frozen_string_literal: true

RSpec.shared_context 'with unauthenticated user' do
  include Schematics::Engine.routes.url_helpers

  subject { response }

  include_context 'with user'

  let(:json_response) { JSON.parse(response.body) }
  let(:accept_header) { 'application/json' }
  let(:headers) { { 'Accept' => accept_header } }
  let(:permissions) { Permission.create_all_entities_permissions! }
  let(:admin_role) { Role.create!(name: 'Admin', permissions:) }

  before { [admin_role, user] }
end

RSpec.shared_context 'with authenticated user' do
  include_context 'with unauthenticated user'

  let(:session) { Session.create!(user:) }
  let(:auth_token) { JsonWebToken.encode(auth_token: session.auth_token) }
  let(:headers) do
    {
      'Accept' => accept_header,
      'Authorization' => "Bearer #{auth_token}"
    }
  end
end

RSpec.shared_context 'with import' do
  include_context 'with user'

  let(:import) { Import.create!(file:, model:, author: user) }
  let(:model) { 'Role' }
  let(:file) do
    ActiveStorage::Blob.create_and_upload!(
      io: File.open(file_fixture('roles.csv'), 'rb'),
      filename: 'roles.csv',
      content_type: Mime[:csv].to_s
    ).signed_id
  end
end

RSpec.shared_context 'with user' do
  let(:reset_password_sent_at) { nil }
  let(:preferences) { {} }
  let(:role) { Role.create!(name: 'Manager') }
  let(:user) do
    User.create!(
      email: 'john.doe@nowhere.com',
      password: 'Azerty1!',
      first_name: 'John',
      last_name: 'Doe',
      role:,
      reset_password_sent_at:,
      preferences:
    )
  end
end

RSpec.shared_context 'with application migration rollback' do |migrations_steps = 1|
  let(:root) { Rails.root }
  let(:rollback_commit) { Git.init(root).reset_hard('HEAD~1') }
  let(:rollback_migration) do
    Dir.chdir(root) do
      ActiveRecord::Base.connection.migration_context.rollback(migrations_steps)
    end
  end
  let(:rollback_reload) do
    schema_dataset.migration_new_entities.each do |entity|
      Object.__send__(:remove_const, entity.class_name.to_sym)
      Object.__send__(:remove_const, :"#{entity.class_name.pluralize}Controller".to_sym)
    end
    schema_dataset.migration_old_entities.each do |entity|
      load root.join('app', 'models', "#{entity.name}.rb")
      load root.join('app', 'controllers', "#{entity.name.pluralize}_controller.rb")
    end
  end

  after { [rollback_migration, rollback_commit, rollback_reload] }
end
