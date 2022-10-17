# frozen_string_literal: true

require 'active_record'
require 'active_record/attribute_methods'

module Schematics
  module Behaviours
    module Inspectable
      delegate :dangerous_attribute_methods, to: '::ActiveRecord::AttributeMethods'

      def inspect = "#{name}:#{type}"

      def type = self
        .class
        .name
        .demodulize
        .underscore
    end
  end
end
