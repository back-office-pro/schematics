# frozen_string_literal: true

module Schematics
  class SearchesDoc < ApplicationDoc
    route_base SearchesController.controller_path

    api :show, 'Global search' do
      path :query, 'string'
      response 200, 'Success', :json
    end
  end
end
