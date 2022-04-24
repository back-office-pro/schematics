# frozen_string_literal: true

class SessionsDoc < Schematics::ApplicationDoc
  route_base SessionsController.controller_path

  api :create, 'Create a session' do
    data 'session[email]', ::String, required: true
    data 'session[password]', ::String, required: true
    data 'session[remember_me]', 'boolean'
    response 200, 'Success', :json
    response 401, 'Not Authorized', :json
  end
end
