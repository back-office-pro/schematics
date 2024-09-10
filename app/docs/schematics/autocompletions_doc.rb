# frozen_string_literal: true

module Schematics
  class AutocompletionsDoc < ApplicationDoc
    route_base AutocompletionsController.controller_path

    api :create, 'Autocompletion' do
      data 'autocompletion[query]', ::String, required: true

      response 200, 'Success', :json, data: [::String]
      response 400, 'Bad Request', :json
      response 401, 'Not Authorized', :json
    end
  end
end
