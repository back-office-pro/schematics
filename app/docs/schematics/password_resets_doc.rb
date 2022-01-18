# frozen_string_literal: true

module Schematics
  class PasswordResetsDoc < ApplicationDoc
    route_base PasswordResetsController.controller_path

    api :create, 'Create a password reset request' do
      data 'user[email]', 'string', required: true
      response 204, 'Success', :json
      response 422, 'Unprocessable entity', :json
    end

    api :update, 'Update user password' do
      path :token, 'string'
      data 'user[password]', 'string'
      data 'user[password_confirmation]', 'string'
      response 204, 'Success', :json
      response 404, 'Not Found', :json
      response 422, 'Unprocessable entity', :json
    end
  end
end
