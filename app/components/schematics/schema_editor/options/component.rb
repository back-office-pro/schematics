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
      end
    end
  end
end
