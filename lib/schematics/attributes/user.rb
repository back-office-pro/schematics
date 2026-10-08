# frozen_string_literal: true

module Schematics
  module Attributes
    class User < Association
      def association_type = 'user'

      def openai_description = 'An attribute which represents the current user'
    end
  end
end
