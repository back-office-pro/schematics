# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

# :reek:MissingSafeMethod
module Core
  module APIKey
    def login!(*) = self

    def touch!(request, response, response_time)
      PaperTrail.request(enabled: false) do
        ::APIRequest.create!(
          api_key: self,
          ip: request.ip,
          request_method: request.method,
          endpoint: request.original_fullpath,
          response_code: response.response_code,
          response_time: (response_time * 1000).to_i
        )
      end
    end

    def user = Schematics::Guest::User.new(permissions:)
  end
end
