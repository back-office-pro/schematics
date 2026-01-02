# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

# :reek:MissingSafeMethod
module Schematics
  module Guest
    class User
      include ::ActiveModel::API
      include ::ActiveModel::Attributes

      attribute :permissions, default: -> { [] }
      attribute :time_zone, default: -> { ::Configuration.time_zone_with_fallback }
      attribute :locale, default: -> { ::Configuration.locale }

      delegate :admin?, to: :role

      def id = nil

      def teams = ::Team.none

      def preferences = {}

      def preferences_theme = nil

      def role = ::Role.new(permissions:)

      def otp_enabled? = false

      def update(*) = false # rubocop:disable Naming/PredicateMethod

      def authenticate(*) = false # rubocop:disable Naming/PredicateMethod

      def log_search!(*) = false # rubocop:disable Naming/PredicateMethod

      def find_or_create_draft!(*) = nil

      def provisioning_uri(*) = nil
    end
  end
end
