# frozen_string_literal: true

module Schematics
  class OneTimePasswordsDoc < ApplicationDoc
    route_base OneTimePasswordsController.controller_path

    api :create, 'Create current user 2FA setup' do
      data 'one_time_password[secret]', ::String, required: true
      data 'one_time_password[attempt]', ::String, required: true
      response 204, 'Success', :json
      response 401, 'Not Authorized', :json
      response 422, 'Unprocessable entity', :json
    end

    api :destroy, 'Remove current user 2FA setup' do
      response 204, 'Success', :json
      response 401, 'Not Authorized', :json
    end
  end
end
