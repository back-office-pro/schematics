# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Options
      class Component < ApplicationComponent
        delegate :available_options, to: '@builder.object'
        renders_one_form :builder

        def initialize(builder:)
          super
          @builder = builder
        end

        def id
          @id ||= "collapse-#{SecureRandom.base58}"
        end

        def input_type = {
          aspect_ratio: :string,
          cached: :boolean,
          confirm: :boolean,
          content_type: :array,
          default: :string,
          depends_on: :string,
          encrypted: :boolean,
          equal_to: :string,
          events: :array,
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
          values: :array,
          width: :string
        }

        def render?
          available_options.any?
        end
      end
    end
  end
end
