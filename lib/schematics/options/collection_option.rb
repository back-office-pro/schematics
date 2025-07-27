# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Options
    # :reek:Attribute
    class CollectionOption < Option
      include ::ActiveModel::API

      attr_accessor :collection

      def input_type = :select

      def multiple? = false

      def controller = 'dropdown'
    end
  end
end
