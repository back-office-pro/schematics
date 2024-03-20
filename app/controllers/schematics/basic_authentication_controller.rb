# frozen_string_literal: true

module Schematics
  class BasicAuthenticationController < ApplicationController
    http_basic_authenticate_with(
      name: Engine.credentials.basic_auth[:username],
      password: Engine.credentials.basic_auth[:password]
    )
  end
end
