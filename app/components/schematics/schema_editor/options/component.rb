# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Options
      class Component < ApplicationComponent
        prepend ViewComponent::GlobalOutputBuffer
        delegate :options, :available_options, to: :@field

        def initialize(field:, form:)
          super
          @field = field
          @form = form
        end

        def id
          @id ||= "collapse-#{SecureRandom.base58}"
        end

        def input_type = {
          aspect_ratio: :string,
          cached: :boolean,
          confirm: :boolean,
          content_type: :select,
          default: :string,
          depends_on: :string,
          encrypted: :boolean,
          equal_to: :string,
          events: :select,
          greater_than: :string,
          greater_than_or_equal_to: :string,
          height: :string,
          hidden: :boolean,
          inverse: :string,
          length: :string,
          less_than: :string,
          less_than_or_equal_to: :string,
          limit: :string,
          max: :string,
          min: :string,
          other_than: :string,
          polymorphic: :boolean,
          precision: :numeric,
          readonly: :boolean,
          required: :boolean,
          scale: :numeric,
          size: :string,
          type: :string,
          unique: :boolean,
          unit: :string,
          values: :select,
          width: :string
        }

        def render?
          available_options.any?
        end
      end
    end
  end
end
