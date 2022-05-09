# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Options
      class Component < ApplicationComponent
        prepend ViewComponent::GlobalOutputBuffer
        delegate :options, to: :@field

        def initialize(field:, form:)
          super
          @field = field
          @form = form
        end

        def available_options # rubocop:disable Metrics/MethodLength, Metrics/CyclomaticComplexity
          case @field
          when Attributes::Attachment
            [
              %i[required boolean],
              %i[size integer],
              %i[aspect_ratio string],
              %i[min integer],
              %i[max integer],
              %i[width integer],
              %i[height integer],
              %i[content_type string]
            ]
          when Attributes::Date
            ::ActiveModel::Validations::Comparability::COMPARE_CHECKS
              .keys
              .map { [_1, :string] }
              .push(%i[required boolean])
          when Attributes::Decimal
            [
              %i[required boolean],
              %i[precision integer],
              %i[scale integer]
            ]
          when Attributes::Digest
            [
              %i[required boolean],
              %i[min integer],
              %i[confirm boolean]
            ]
          when Attributes::String
            [
              %i[unique boolean],
              %i[required boolean],
              %i[min integer],
              %i[limit integer],
              %i[length integer]
            ]
          when Attributes::Attribute
            [
              %i[unique boolean],
              %i[required boolean]
            ]
          when Virtuals::Calculation
            [
              %i[unit string],
              %i[precision integer]
            ]
          else
            []
          end
        end
      end
    end
  end
end
