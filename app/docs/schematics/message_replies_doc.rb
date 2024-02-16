# frozen_string_literal: true

module Schematics
  class MessageRepliesDoc < ApplicationDoc
    route_base MessageRepliesController.controller_path

    api :create, 'Reply to a message' do
      path :message_id, ::String

      data 'message[content]', ::String, required: true

      body :json, data: ::Message.entity.open_api_body

      response 201, 'Success', :json, data: ::Message.entity.open_api_schema
      response 400, 'Bad Request', :json
      response 401, 'Not Authorized', :json
      response 422, 'Unprocessable entity', :json
    end
  end
end
