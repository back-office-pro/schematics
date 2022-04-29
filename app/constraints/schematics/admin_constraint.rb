# frozen_string_literal: true

module Schematics
  class AdminConstraint
    class << self
      def matches?(request)
        ::Session
          .where(auth_token: request.cookies['auth_token'])
          .or(::Session.active.where(id: request.session['current_session_id']))
          .first
          &.user
          &.admin?
      end
    end
  end
end
