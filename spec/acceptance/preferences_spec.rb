require 'rails_helper'
require 'rspec_api_documentation/dsl'
require 'schematics/specs/helpers'

resource 'Preferences' do
  extend Schematics::Specs::Helpers

  shared_setup
  token_auth

  put '/preferences' do
    with_options scope: :preferences, with_example: true do
      parameter :sidebar_toggled, 'The sidebar status'
      parameter :theme, 'The application theme'
    end

    context 'when updating application theme' do
      let(:theme) { 'light' }

      example 'Success' do
        do_request
        expect(response_status).to eq(200)
        expect(response_body).to be_blank
      end
    end
  end
end
