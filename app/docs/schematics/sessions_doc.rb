# frozen_string_literal: true

module Schematics
  class SessionsDoc < ApplicationDoc
    route_base SessionsController.controller_path

    api :create, 'Create a session' do
      data 'user[email]', ::String, required: true
      data 'user[password]', ::String, required: true
      data 'user[remember_me]', 'boolean'
      response 200, 'Success', :json
      response 401, 'Not Authorized', :json
    end

    api :update, 'Update user profile' do
      data 'user[email]', ::String
      data 'user[password]', ::String
      data 'user[password_confirmation]', ::String
      data 'user[current_password]', ::String
      data 'user[first_name]', ::String
      data 'user[last_name]', ::String
      data 'user[avatar]', ::String
      data 'user[locale]', ::String
      data 'user[role]', ::String
      response 204, 'Success', :json
      response 422, 'Unprocessable entity', :json
    end
  end
end
