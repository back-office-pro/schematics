# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Options
    class InverseAssociationType < Option
      class << self
        def input_type = :select

        def multiple? = false

        def controller = 'dropdown'

        def collection = %w[has_many has_one]
          .map { [I18n.t(_1, scope: %i[activemodel attributes schematics/options/wrapper inverse_association_types]), _1] } # rubocop:disable Layout/LineLength
          .sort
      end
    end
  end
end
