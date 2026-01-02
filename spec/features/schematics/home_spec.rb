# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Home' do
  include Schematics::ResourcesHelper

  include_context 'with login'
  include_context 'with admin role'

  let(:role) { admin_role }

  before { user.create_search_index }

  it 'searches for user with typeahead', :js do # rubocop:disable RSpec/ExampleLength
    find('.toast').click_button
    find('i[data-bs-target="#search-bar-modal"]').click
    fill_in 'search[query]', with: user.email
    page.driver.wait_for_network_idle # Ajax
    find('ul[data-search-bar-target="results"] > li:first-child').click
    page.driver.wait_for_network_idle # Turbo
    expect(page).to have_current_path(resource_path(user))
  end

  it 'searches for user globally', :js do # rubocop:disable RSpec/ExampleLength
    find('.toast').click_button
    find('i[data-bs-target="#search-bar-modal"]').click
    fill_in 'search[query]', with: user.email
    find('.modal-body').click_button
    page.driver.wait_for_network_idle # Turbo
    expect(page).to have_current_path(resource_path(Search.last))
  end
end
