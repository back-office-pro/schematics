# frozen_string_literal: true

module Schematics
  module Attributes
    class References < Association
      def association_type = 'user'
    end
  end
end
