require 'rails_helper'
require 'rspec_api_documentation/dsl'
require 'schematics/specs/helpers'

resource 'Sessions' do
  extend Schematics::Specs::Helpers

  shared_setup
  fixtures :users
  fixtures :roles

  let(:user) { users(:two) }
  let(:email) { user.email }
  let(:auth_token) { JsonWebToken.encode({ auth_token: user.auth_token }) }

  post '/sessions' do
    with_options scope: :user, with_example: true do
      parameter :email, 'The user email', required: true
      parameter :password, 'The user password', required: true
    end

    context 'when credentials are correct' do
      let(:password) { 'secret' }

      example 'Success' do
        do_request
        expect(response_status).to eq(200)
        expect(json_response).to eq({ 'auth_token' => auth_token })
      end
    end

    context 'when credentials are wrong' do
      let(:password) { 'qwerty' }

      example 'Not authorized' do
        do_request
        expect(response_status).to eq(401)
        expect(response_body).to be_blank
      end
    end
  end

  put '/sessions' do
    token_auth

    with_options scope: :user, with_example: true do
      parameter :email, 'The user email'
      parameter :password, 'The user password'
      parameter :password_confirmation, 'The user password confirmation'
      parameter :current_password, 'The user current password', required: true
      parameter :first_name, 'The user first name'
      parameter :last_name, 'The user last name'
      parameter :avatar, 'The user avatar'
      parameter :locale, 'The user locale'
      parameter :role, 'The user role'
    end

    context 'when current_password is right' do
      let(:current_password) { 'secret' }

      example 'update profile' do
        do_request
        expect(response_status).to eq(204)
        expect(response_body).to be_blank
      end
    end

    context 'when current_password is wrong' do
      let(:current_password) { 'qwerty' }
      let(:expected_response) do
        {
          'errors' => [
            I18n.t('schematics.sessions.update.failure'),
          ],
        }
      end

      example 'update profile' do
        do_request
        expect(response_status).to eq(422)
        expect(json_response).to eq(expected_response)
      end
    end
  end
end
