# frozen_string_literal: true

require 'active_record'
require 'active_record/attribute_methods'
require 'active_support/concern'

module Schematics
  module Behaviours
    # :reek:Attribute
    module Nameable
      extend ActiveSupport::Concern

      NAME_REGEX = %r{\A([a-z_/]+)\z}

      attr_reader :name

      delegate :dangerous_attribute_methods, to: ::ActiveRecord::AttributeMethods, private: true

      included do
        validates :name,
                  presence: true,
                  format: { with: NAME_REGEX, message: :name },
                  length: { maximum: 50 },
                  exclusion: { in: :dangerous_attribute_methods, message: :dangerous_attribute }
      end

      def name=(value)
        @name = value&.strip
      end
    end
  end
end
