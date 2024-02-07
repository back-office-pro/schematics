# frozen_string_literal: true

module Schematics
  class MessageRepliesDoc < ApplicationDoc
    route_base MessageRepliesController.controller_path

    api :create, 'Reply to a message' do
      path :message_id, ::String

      data 'message[content]', ::String, required: true

      body :json, data: {
        message: {
          content: ::String
        }
      }

      response 201, 'Success', :json, data: ::Message
        .entity
        .renderable_elements_without_has_many_associations
        .stable_sort_by(&:weight)
        .to_h { [_1.name, _1.open_api_type] }
      response 400, 'Bad Request', :json
      response 401, 'Not Authorized', :json
      response 422, 'Unprocessable entity', :json
    end
  end
end
