# frozen_string_literal: true

module Schematics
  class ProfileDoc < ApplicationDoc
    route_base ProfileController.controller_path

    api :update, 'Update user profile' do
      data 'user[email]', ::String
      data 'user[password]', ::String
      data 'user[password_confirmation]', ::String
      data 'user[current_password]', ::String
      data 'user[first_name]', ::String
      data 'user[last_name]', ::String
      data 'user[avatar]', ::String
      data 'user[locale]', ::String
      response 204, 'Success', :json
      response 422, 'Unprocessable entity', :json
    end
  end
end
