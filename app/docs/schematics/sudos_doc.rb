# frozen_string_literal: true

module Schematics
  class SudosDoc < ApplicationDoc
    route_base SudosController.controller_path

    api :create, 'Create a sudo request' do
      data 'user[password]', ::String, required: true

      body :json, data: {
        user: {
          password: ::String
        }
      }

      response 201, 'Success', :json
      response 400, 'Bad Request', :json
      response 401, 'Not Authorized', :json
      response 422, 'Unprocessable entity', :json
    end
  end
end
