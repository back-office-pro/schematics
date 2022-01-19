# frozen_string_literal: true

module Schematics
  class PreferencesDoc < ApplicationDoc
    route_base PreferencesController.controller_path

    api :update, 'Update current user preferences' do
      response 204, 'Success', :json
    end
  end
end
