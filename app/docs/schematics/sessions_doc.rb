# frozen_string_literal: true

module Schematics
  class SessionsDoc < ApplicationDoc
    route_base SessionsController.controller_path

    api :create, 'Create a session' do
      data 'user[email]', 'string', required: true
      data 'user[password]', 'string', required: true
      data 'user[remember_me]', 'boolean'
      response 200, 'Success', :json
      response 401, 'Not Authorized', :json
    end

    api :update, 'Update user profile' do
      data 'user[email]', 'string'
      data 'user[password]', 'string'
      data 'user[password_confirmation]', 'string'
      data 'user[current_password]', 'string'
      data 'user[first_name]', 'string'
      data 'user[last_name]', 'string'
      data 'user[avatar]', 'string'
      data 'user[locale]', 'string'
      data 'user[role]', 'string'
      response 204, 'Success', :json
      response 422, 'Unprocessable entity', :json
    end
  end
end
