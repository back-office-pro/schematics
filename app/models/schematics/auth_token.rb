# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

module Schematics
  class AuthToken
    TOKEN_TYPE = 'Bearer'
    ACCESS_TOKEN_DURATION = 10.minutes.freeze
    REFRESH_TOKEN_DURATION = 1.day.freeze

    delegate :generate_token_for, to: :@session, private: true

    def initialize(session)
      @session = session
    end

    def as_json(*) = {
      token_type: TOKEN_TYPE,
      expires_in: ACCESS_TOKEN_DURATION.to_i,
      access_token: generate_token_for(:access_token),
      refresh_token: generate_token_for(:refresh_token)
    }
  end
end
