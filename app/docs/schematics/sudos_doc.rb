# frozen_string_literal: true

module Schematics
  class SudosDoc < ApplicationDoc
    route_base SudosController.controller_path

    api :create, 'Create a sudo request' do
      data 'user[password]', ::String, required: true
      response 204, 'Success', :json
      response 422, 'Unprocessable entity', :json
    end
  end
end
