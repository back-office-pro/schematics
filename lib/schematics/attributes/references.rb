# frozen_string_literal: true

module Schematics
  module Attributes
    class References < Association
      # by convention, this attribute will always be set to current user
      def options = super.tap { _1.merge!(type: 'user') }
    end
  end
end
