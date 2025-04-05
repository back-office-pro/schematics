# Copyright © 2025 Dev & Software. All rights reserved.
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

RSpec.shared_context 'with stripe stubs' do
  let(:new_metadata) do
    {
      users: 1000,
      api_keys: 100,
      storage: 100,
      entities: 100,
      prompts: 100,
      support: 1
    }
  end
  let(:search_body) do
    {
      data: [
        {
          id: 'cus_1',
          email: 'john.doe@nowhere.com',
          preferred_locales: [],
          metadata: {
            business_sector: 'construction'
          },
          subscriptions: [
            {
              id: 'sub_1',
              status: 'active',
              cancel_at_period_end: false,
              plan: {
                product: 'prod_1'
              }
            }
          ]
        }
      ]
    }
  end
  let(:product_body) do
    {
      name: 'premium',
      metadata: new_metadata
    }
  end
  let(:subscription_stub_request) do
    stub_request(:post, 'https://api.stripe.com/v1/subscriptions/sub_1')
      .to_return(status: 200)
  end

  before do
    stub_request(:get, %r{https://api.stripe.com/v1/customers/search})
      .to_return(body: search_body.to_json, status: 200)
    stub_request(:get, 'https://api.stripe.com/v1/products/prod_1')
      .to_return(body: product_body.to_json, status: 200)
    subscription_stub_request
  end
end

RSpec.shared_context 'with google translate stub' do
  let(:body) do
    {
      data: {
        translations: [
          { translatedText: 'Subtitle' }
        ]
      }
    }.to_json
  end

  before do
    stub_request(:post, %r{https://translation.googleapis.com/language/translate/v2})
      .to_return(body:, status: 200)
  end
end

RSpec.shared_context 'with password pwned stub' do
  before do
    stub_request(:get, %r{https://api.pwnedpasswords.com}).to_return(status: 200)
  end
end

RSpec.shared_context 'with openai stub' do
  before do
    stub_request(:post, 'https://api.openai.com/v1/chat/completions')
      .to_return(
        body: file_fixture('open_ai.json').read,
        headers: { 'Content-Type' => 'application/json' },
        status: 200
      )
  end
end
