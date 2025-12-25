# Copyright © 2025 Dev & Software. All rights reserved.
#
# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

module Core
  module Sessions
    class Omniauthenticate
      include Schematics::Interactable

      delegate :resource_params, to: :context, private: true
      delegate :otp_enabled?, :generate_token_for, to: :user, allow_nil: true, private: true

      def call
        return unless resource_params in OmniAuth::AuthHash::InfoHash

        context.user = user
        context.otp_token = otp_token
      end

      private

      memoize def user = ::User.find_by(email:)

      def otp_token
        generate_token_for(:one_time_password) if otp_enabled?
      end

      def email = resource_params[:email]
    end
  end
end
