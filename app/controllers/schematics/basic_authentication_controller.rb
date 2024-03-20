# frozen_string_literal: true

module Schematics
  class BasicAuthenticationController < ApplicationController
    http_basic_authenticate_with(
      name: Engine.credentials.backend[:username],
      password: Engine.credentials.backend[:password]
    )
  end
end
