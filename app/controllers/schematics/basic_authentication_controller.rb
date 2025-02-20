# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class BasicAuthenticationController < ApplicationController
    allow_unauthenticated_access
    http_basic_authenticate_with(
      name: Engine.credentials.basic_auth.username,
      password: Engine.credentials.basic_auth.password
    )
  end
end
