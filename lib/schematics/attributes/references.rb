# frozen_string_literal: true

module Schematics
  module Attributes
    # :reek:InstanceVariableAssumption
    class References < Association
      # by convention, this attribute will always be set to current user
      def options
        Schematics::Options.new(options: @options.merge(type: 'user'))
      end
    end
  end
end
