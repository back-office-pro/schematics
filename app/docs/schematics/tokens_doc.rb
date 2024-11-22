# frozen_string_literal: true

module Schematics
  class TokensDoc < ApplicationDoc
    route_base TokensController.controller_path

    api :create, 'Create a new access token' do
      data 'refresh_token', ::String, required: true

      body :json, data: { refresh_token: ::String }

      response 201, 'Success', :json, data: Schematics::AuthToken.open_api_schema
      response 400, 'Bad Request', :json
      response 401, 'Not Authorized', :json
    end
  end
end
