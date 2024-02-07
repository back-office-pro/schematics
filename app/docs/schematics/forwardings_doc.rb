# frozen_string_literal: true

module Schematics
  class ForwardingsDoc < ApplicationDoc
    route_base ForwardingsController.controller_path

    api :create, 'Forward a resource by e-mail' do
      data 'forwarding[recipient_ids][]', [::String], required: true

      body :json, data: {
        forwarding: {
          recipient_ids: [::String]
        }
      }

      response 201, 'Success', :json
      response 400, 'Bad Request', :json
      response 401, 'Not Authorized', :json
      response 422, 'Unprocessable entity', :json
    end
  end
end
