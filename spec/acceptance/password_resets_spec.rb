# frozen_string_literal: true

require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Password Resets' do
  extend Schematics::Specs::Helpers

  shared_setup
  fixtures :users
  fixtures :roles

  let(:user) { users(:two) }

  post '/password_resets' do
    with_options scope: :user, with_example: true do
      parameter :email, 'The user email', required: true
    end

    context 'when email exists' do
      let(:email) { user.email }

      example 'Creating a new password reset' do
        do_request
        expect(response_status).to eq(204)
        expect(response_body).to be_blank
      end
    end

    context 'when email does not exist' do
      let(:email) { 'foo@foo.com' }
      let(:expected_response) do
        {
          'errors' => [
            I18n.t('schematics.password_resets.create.failure')
          ]
        }
      end

      example 'Unprocessable entity' do
        do_request
        expect(response_status).to eq(422)
        expect(json_response).to eq(expected_response)
      end
    end
  end

  put '/password_resets/:token' do
    with_options with_example: true do
      parameter :token, 'The password reset token', required: true
    end

    with_options scope: :user, with_example: true do
      parameter :password, 'The new user password', required: true
      parameter :password_confirmation, 'The new user password confirmation', required: true
    end

    context 'when token exists' do
      let(:token) { user.password_reset_token }

      context 'when password is equal to password_confirmation' do
        let(:password) { 'Azerty1!' }
        let(:password_confirmation) { 'Azerty1!' }

        example 'Updating the password' do
          do_request
          expect(response_status).to eq(204)
          expect(response_body).to be_blank
        end
      end

      context 'when password is not equal to password_confirmation' do
        let(:password) { 'Azerty1!' }
        let(:password_confirmation) { 'Azerty1' }
        let(:expected_response) do
          {
            'errors' => [
              I18n.t('schematics.resources.update.failure')
            ]
          }
        end

        example 'Unprocessable entity' do
          do_request
          expect(response_status).to eq(422)
          expect(json_response).to eq(expected_response)
        end
      end
    end

    context 'when token does not exist' do
      let(:token) { 'foo' }

      example 'Not found' do
        do_request
        expect(response_status).to eq(404)
        expect(response_body).to be_blank
      end
    end
  end
end
