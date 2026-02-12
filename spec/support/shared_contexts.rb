# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

RSpec.shared_context 'with unauthenticated user' do
  subject { response }

  include_context 'with user'

  let(:accept_header) { 'application/json' }
  let(:headers) { { 'Accept' => accept_header } }

  before { user }
end

RSpec.shared_context 'with authenticated user' do
  include_context 'with unauthenticated user'

  let(:session) { Session.create!(user:) }
  let(:access_token) { session.generate_token_for(:access_token) }
  let(:headers) do
    {
      'Accept' => accept_header,
      'Authorization' => "#{Schematics::AuthToken::TOKEN_TYPE} #{access_token}"
    }
  end
end

RSpec.shared_context 'with admin role' do
  let(:permissions) { Permission.create_entities_permissions! }
  let(:admin_role) { Role.create!(name: 'Admin', permissions:) }

  before { admin_role }
end

RSpec.shared_context 'with import' do
  include_context 'with user'

  let(:import) { Import.create!(file:, resources:, model:, author: user).reload }
  let(:model) { 'User' }
  let(:resources) { nil }
  let(:file) do
    ActiveStorage::Blob.create_and_upload!(
      io: file_fixture('users.csv').open,
      filename: 'users.csv',
      content_type: Mime[:csv].to_s
    )
  end
end

RSpec.shared_context 'with user' do
  let(:preferences) { {} }
  let(:teams) do
    [
      Team.create!(name: 'My Team 1'),
      Team.create!(name: 'My Team 2')
    ]
  end
  let(:role) do
    Role.create!(
      name: 'Manager',
      permissions: [Permission.create!(action: 'index', model: 'Import')]
    )
  end
  let(:user) do
    User.create!(
      email: 'john.doe@nowhere.com',
      password: Schematics::Attributes::Digest::DEFAULT,
      first_name: 'John',
      last_name: 'Doe',
      role:,
      preferences:,
      teams:
    )
  end
end

RSpec.shared_context 'with login' do
  include_context 'with user'

  before do
    visit login_path
    within '.card-body' do
      fill_in 'session[email]', with: user.email
      fill_in 'session[password]', with: user.password
      click_button
      page.driver.wait_for_network_idle
    end
  end
end

RSpec.shared_context 'with google translate stub' do
  let(:body) do
    {
      data: {
        translations: [
          translatedText: 'Subtitle'
        ]
      }
    }.to_json
  end

  before do
    stub_request(:post, %r{https://translate.googleapis.com/language/translate/v2})
      .to_return(body:, status: 200)
  end
end

RSpec.shared_context 'with password pwned stub' do
  before do
    stub_request(:get, %r{https://api.pwnedpasswords.com}).to_return(status: 200)
  end
end

RSpec.shared_context 'with aws stub' do
  before do
    stub_request(:put, %r{https://s3.af-south-1.amazonaws.com}).to_return(status: 200)
  end
end

RSpec.shared_context 'with openai stub' do
  before do
    stub_request(:post, 'https://api.openai.com/v1/chat/completions')
      .to_return(
        body: file_fixture('openai.json').read,
        headers: { 'Content-Type' => 'application/json' },
        status: 200
      )
  end
end

RSpec.shared_context 'with active license' do
  let(:license) do
    instance_double(
      Schematics::License,
      active?: true,
      expires_at: nil,
      storage_quota_will_be_exceeded?: false,
      entities_quota_will_be_exceeded?: false,
      users_quota_exceeded?: false,
      webhooks_quota_exceeded?: false,
      api_keys_quota_exceeded?: false,
      roles_quota_exceeded?: false,
      teams_quota_exceeded?: false
    )
  end

  before do
    allow(Configuration).to receive(:license).and_return(license)
    allow_any_instance_of(Configuration).to receive(:active_license).and_return(true) # rubocop:disable RSpec/AnyInstance
  end
end
