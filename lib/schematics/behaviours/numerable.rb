# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'active_model/validations/comparability'

module Schematics
  module Behaviours
    module Numerable
      delegate :unit,
               :precision,
               :separator,
               :greater_than,
               :greater_than_or_equal_to,
               :less_than,
               :less_than_or_equal_to,
               :equal_to,
               :other_than,
               to: :options

      def available_options = super.push(
        Options::GreaterThan,
        Options::GreaterThanOrEqualTo,
        Options::EqualTo,
        Options::LessThan,
        Options::LessThanOrEqualTo,
        Options::OtherThan
      )

      def default # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
        equal_to ||
          greater_than_or_equal_to ||
          greater_than&.next ||
          less_than_or_equal_to ||
          less_than&.pred ||
          other_than&.next
      end

      # :reek:NilCheck
      def format(value)
        case value
        when nil, StandardError
          super
        else
          case unit
          when 'bytes'
            number_to_human_size(value, **{ precision:, separator: }.compact)
          when '%'
            number_to_percentage(value, **{ precision:, separator: }.compact)
          when '€', '$', '£', '¥'
            number_to_currency(value, **{ unit:, precision:, separator: }.compact)
          else
            [number_with_precision(value, **{ precision:, separator: }.compact), unit]
              .compact
              .join(' ')
          end
        end
      end

      def icon = :arrow_up_1_9 # rubocop:disable Naming/VariableNumber

      def validators = super.merge(
        numericality: options
                      .slice(*::ActiveModel::Validations::Comparability::COMPARE_CHECKS.keys)
                      .to_h
                      .merge(allow_blank:)
      )
    end
  end
end
