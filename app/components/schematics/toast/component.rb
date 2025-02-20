# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Toast
    class Component < ApplicationComponent
      delegate :first, :second, to: :@flash
      with_collection_parameter :flash

      alias type first
      alias message second

      def initialize(flash:)
        super
        @flash = flash
      end

      def css_class = { notice: 'success', alert: 'danger' }[type.to_sym]
    end
  end
end
