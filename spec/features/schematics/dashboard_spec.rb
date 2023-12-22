# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Dashboard' do
  include_context 'with login'
  include_context 'with admin role'

  let(:role) { admin_role }

  it 'searches for user with typeahead', :js do # rubocop:disable RSpec/ExampleLength
    find('.toast').click_button
    find('i[data-bs-target="#search-bar-modal"]').click
    fill_in 'search[query]', with: user.email
    sleep(5) # Ajax
    find('ul[data-search-bar-target="results"] > li:first-child').click
    sleep(5) # Turbo
    expect(page).to have_current_path(user_path(user))
  end

  it 'searches for user globally', :js do # rubocop:disable RSpec/ExampleLength
    find('.toast').click_button
    find('i[data-bs-target="#search-bar-modal"]').click
    fill_in 'search[query]', with: user.email
    find('.modal-body').click_button
    sleep(5) # Turbo
    expect(page).to have_current_path(search_path(Search.last))
  end
end
