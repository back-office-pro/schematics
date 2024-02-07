# frozen_string_literal: true

module Schematics
  class ProfileDoc < ApplicationDoc
    route_base ProfileController.controller_path

    api :update, 'Update current user profile' do
      data 'user[email]', ::String
      data 'user[password]', ::String
      data 'user[password_confirmation]', ::String
      data 'user[password_challenge]', ::String, required: true
      data 'user[first_name]', ::String
      data 'user[last_name]', ::String
      data 'user[avatar]', ::String
      data 'user[locale]', ::String

      body :json, data: {
        user: {
          email: ::String,
          password: ::String,
          password_confirmation: ::String,
          password_challenge: ::String,
          first_name: ::String,
          last_name: ::String,
          avatar: ::String,
          locale: ::String
        }
      }

      response 204, 'Success', :json
      response 400, 'Bad Request', :json
      response 401, 'Not Authorized', :json
      response 422, 'Unprocessable entity', :json
    end
  end
end
