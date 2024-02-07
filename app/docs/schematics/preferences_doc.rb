# frozen_string_literal: true

module Schematics
  class PreferencesDoc < ApplicationDoc
    route_base PreferencesController.controller_path

    api :update, 'Update current user preferences' do
      data 'user[preferences][theme]', ::String
      data 'user[preferences][sidebar_toggled]', 'boolean'

      body :json, data: {
        user: {
          preferences: {
            theme: ::String,
            sidebar_toggled: 'boolean'
          }
        }
      }

      response 204, 'Success', :json
      response 401, 'Not Authorized', :json
    end
  end
end
