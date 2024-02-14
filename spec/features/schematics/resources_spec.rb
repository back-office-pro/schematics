# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Resources' do
  include_context 'with login'
  include_context 'with admin role'

  let(:role) { admin_role }
  let(:column_css_class) do
    "col_#{User.entity.id}_#{User.entity.find_field_by_name('email').id}"
  end

  it 'filters by email', :js do # rubocop:disable RSpec/ExampleLength
    visit users_path
    fill_in 'filter[email]', with: user.email
    page.driver.wait_for_network_idle # Ajax
    find('ul[data-typeahead-target="results"] > li:first-child').click
    page.driver.wait_for_network_idle # Turbo
    expect(page).to have_current_path(users_path(filter: { email: user.email }))
  end

  it 'edits email in place', :js do # rubocop:disable RSpec/ExampleLength
    visit user_path(user)
    first('.card-body .edit-in-place').click
    page.driver.wait_for_network_idle # Turbo
    fill_in 'user[email]', with: 'admin@nowhere.com'
    first('.card-body turbo-frame').click_button
    page.driver.wait_for_network_idle # Turbo
    expect(user.reload.email).to eq('admin@nowhere.com')
  end

  it 'compares permissions', :js do # rubocop:disable RSpec/ExampleLength
    visit permissions_path
    check Permission.last.id
    check Permission.second_to_last.id
    find('.table').click_button
    page.driver.wait_for_network_idle # Turbo
    expect(page).to have_current_path(comparison_path(Comparison.last))
  end

  it 'hides user email column', :js do
    skip('not working on CI') if ENV['CI'].present?
    visit users_path
    find_by_id('settings-dropdown').click
    uncheck column_css_class
    expect(find("th.#{column_css_class}", visible: :all)).not_to be_visible
  end

  it 'automatically saves the form content', :js do # rubocop:disable RSpec/ExampleLength
    visit new_user_path
    fill_in('user[email]', with: user.email).send_keys(:tab)
    sleep(5) # Ajax
    refresh
    sleep(5)
    find('.card-header').click_button
    expect(page).to have_field('user_email', with: user.email)
  end
end
