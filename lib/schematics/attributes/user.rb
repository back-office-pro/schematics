# frozen_string_literal: true

module Schematics
  module Attributes
    class User < Association
      def association_type = 'user'
    end
  end
end
