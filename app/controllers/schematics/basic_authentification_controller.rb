# frozen_string_literal: true

module Schematics
  class BasicAuthentificationController < ::ActionController::Base
    http_basic_authenticate_with(
      name: Engine.credentials.auth_basic[:username],
      password: Engine.credentials.auth_basic[:password]
    )
  end
end
