# frozen_string_literal: true

require 'active_support/concern'

module ActiveModel
  module NestedAttributes
    extend ActiveSupport::Concern

    class_methods do
      def accepts_nested_attributes_for(attribute_name)
        define_method(:"#{attribute_name}_attributes=") do |value|
          public_send(:"#{attribute_name}=", value)
        end
      end
    end
  end
end
