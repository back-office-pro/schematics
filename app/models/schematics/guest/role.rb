# frozen_string_literal: true

module Schematics
  module Guest
    class Role
      include ::ActiveModel::API

      def permissions = [
        ::Permission.new(action: 'create', model: 'Session')
      ]
    end
  end
end
