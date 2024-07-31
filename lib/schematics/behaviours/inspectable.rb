# frozen_string_literal: true

require 'active_support/concern'

module Schematics
  module Behaviours
    module Inspectable
      extend ActiveSupport::Concern

      included do
        delegate :type, to: :class
      end

      class_methods do
        def type = name
          .demodulize
          .underscore
      end

      def inspect = "#{name}:#{type}"
    end
  end
end
