# frozen_string_literal: true

module Schematics
  class PasswordResetsDoc < ApplicationDoc
    route_base PasswordResetsController.controller_path

    api :create, 'Create a password reset request' do
      data 'user[email]', ::String, required: true
      response 204, 'Success', :json
      response 422, 'Unprocessable entity', :json
    end

    api :update, 'Update user password' do
      path :token, ::String
      data 'user[password]', ::String
      data 'user[password_confirmation]', ::String
      response 204, 'Success', :json
      response 404, 'Not Found', :json
      response 422, 'Unprocessable entity', :json
    end
  end
end
