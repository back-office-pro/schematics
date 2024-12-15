# frozen_string_literal: true

module Schematics
  class OneTimePasswordsDoc < ApplicationDoc
    route_base OneTimePasswordsController.controller_path

    api :show, 'Get current user 2FA recovery codes' do
      response 200, 'Success', :json, data: [codes: [::String]]
      response 401, 'Not Authorized', :json
    end

    api :create, 'Unlock two-factor session' do
      data 'user[otp_token]', ::String, required: true
      data 'user[otp_attempt]', ::String, required: true
      data 'user[remember_me]', 'boolean'

      body :json, data: {
        user: {
          otp_token: ::String,
          otp_attempt: ::String,
          remember_me: 'boolean'
        }
      }

      response 200, 'Success', :json, data: Schematics::AuthToken.open_api_schema
      response 400, 'Bad Request', :json
      response 401, 'Not Authorized', :json
    end

    api :update, 'Update current user 2FA setup' do
      data 'user[otp_attempt]', ::String, required: true

      body :json, data: {
        user: {
          otp_attempt: ::String
        }
      }

      response 204, 'Success', :json
      response 400, 'Bad Request', :json
      response 401, 'Not Authorized', :json
      response 422, 'Unprocessable entity', :json
    end

    api :destroy, 'Remove current user 2FA setup' do
      response 204, 'Success', :json
      response 401, 'Not Authorized', :json
    end
  end
end
