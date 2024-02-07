# frozen_string_literal: true

module Core
  class SessionsDoc < Schematics::ApplicationDoc
    route_base SessionsController.controller_path

    api :create, 'Create a session' do
      data 'session[email]', ::String, required: true
      data 'session[password]', ::String, required: true
      data 'session[remember_me]', 'boolean'

      body :json, data: {
        session: {
          email: ::String,
          password: ::String,
          remember_me: 'boolean'
        }
      }

      response 200, 'Success', :json, data: { auth_token: ::String }
      response 400, 'Bad Request', :json
      response 401, 'Not Authorized', :json
    end
  end
end
