# frozen_string_literal: true

require 'active_record'
require 'active_record/attribute_methods'

module Schematics
  module Behaviours
    module Identifiable
      # :reek:Attribute
      attr_writer :id

      delegate :dangerous_attribute_methods,
               to: ::ActiveRecord::AttributeMethods,
               private: true

      def id
        @id ||= SecureRandom.uuid
      end
    end
  end
end
