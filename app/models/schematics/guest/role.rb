# frozen_string_literal: true

module Schematics
  module Guest
    class Role
      def permissions
        [
          ::Permission.new(action: 'create', model: 'Session')
        ]
      end
    end
  end
end
