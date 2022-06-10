# frozen_string_literal: true

module Schematics
  class AdminConstraint
    class << self
      def matches?(request)
        ::Session
          .authorized_by(request.cookies['auth_token'], request.session['current_session_id'])
          .first
          &.user
          &.admin?
      end
    end
  end
end
