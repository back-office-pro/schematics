# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Resources' do
  include Schematics::ResourcesHelper

  include_context 'with login'
  include_context 'with admin role'

  let(:role) { admin_role }
  let(:column_css_class) do
    "col_#{User.entity.id}_#{User.entity.find_field_by_name('email').id}"
  end

  before { user.create_search_index }

  it 'filters by email', :js do # rubocop:disable RSpec/ExampleLength
    visit resources_path(User)
    fill_in 'filter[email]', with: user.email
    page.driver.wait_for_network_idle # Ajax
    find('ul[data-typeahead-target="results"] > li:first-child').click
    page.driver.wait_for_network_idle # Turbo
    expect(page).to have_current_path(resources_path(User, filter: { email: user.email }))
  end

  it 'edits email in place', :js do # rubocop:disable RSpec/ExampleLength
    visit resource_path(user)
    first('.card-body .edit-in-place').click
    page.driver.wait_for_network_idle # Turbo
    fill_in 'user[email]', with: 'admin@nowhere.com'
    first('.card-body turbo-frame').click_button
    page.driver.wait_for_network_idle # Turbo
    expect(user.reload.email).to eq('admin@nowhere.com')
  end

  it 'compares permissions', :js do # rubocop:disable RSpec/ExampleLength
    visit resources_path(Permission)
    check Permission.last.id
    check Permission.second_to_last.id
    find('.table').click_button
    page.driver.wait_for_network_idle # Turbo
    expect(page).to have_current_path(resource_path(Comparison.last))
  end

  it 'hides user email column', :js do
    skip('not working on CI') if ENV['CI'].present?
    visit resources_path(User)
    find_by_id('settings-dropdown').click
    uncheck column_css_class
    expect(find("th.#{column_css_class}", visible: :all)).not_to be_visible
  end

  it 'automatically saves the form content', :js do # rubocop:disable RSpec/ExampleLength
    visit new_resource_path(User)
    fill_in('user[email]', with: user.email).send_keys(:tab)
    sleep(5) # Ajax
    refresh
    sleep(5)
    find('.card-header').click_button
    expect(page).to have_field('user_email', with: user.email)
  end

  it 'automatically saves the form content even if offline', :js do # rubocop:disable RSpec/ExampleLength
    visit new_resource_path(User)
    page.driver.browser.network.offline_mode
    fill_in('user[email]', with: user.email).send_keys(:tab)
    page.driver.browser.network.emulate_network_conditions(
      offline: false,
      latency: 0,
      download_throughput: 0,
      upload_throughput: 0
    )
    sleep(5) # Ajax
    refresh
    sleep(5)
    find('.card-header').click_button
    expect(page).to have_field('user_email', with: user.email)
  end

  it 'downloads a CSV file', :js, skip: 'not supported by driver' do
    visit resources_path(Permission)
    find_by_id('generate_file_in_background').click
    page.driver.browser.downloads.wait { first('#generate_file_in_background .dropdown-item').click } # rubocop:disable Layout/LineLength
    expect(page.driver.browser.downloads.files.first['suggestedFilename']).to eq('permissions.csv')
  end

  it 'downloads a PDF file', :js, skip: 'not supported by driver' do
    visit resource_path(user)
    page.driver.browser.downloads.wait { find_by_id('generate_file_in_background').click }
    expect(page.driver.browser.downloads.files.first['suggestedFilename']).to eq('user-john-doe.pdf') # rubocop:disable Layout/LineLength
  end
end
