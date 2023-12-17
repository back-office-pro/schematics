# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Resources' do
  include_context 'with login'
  include_context 'with admin role'

  let(:role) { admin_role }

  it 'filters by email', :js do # rubocop:disable RSpec/ExampleLength
    visit users_path
    fill_in 'filter[email]', with: user.email
    sleep(5) # Ajax
    find('ul[data-typeahead-target="results"] > li:first-child').click
    sleep(5) # Turbo
    expect(page).to have_current_path(users_path(filter: { email: user.email }))
  end

  it 'edits email in place', :js do # rubocop:disable RSpec/ExampleLength
    visit user_path(user)
    find('.card-body .edit-in-place', match: :first).click
    sleep(5) # Turbo
    fill_in 'user[email]', with: 'admin@nowhere.com'
    find('.card-body turbo-frame', match: :first).click_button
    sleep(5) # Turbo
    expect(user.reload.email).to eq('admin@nowhere.com')
  end
end
