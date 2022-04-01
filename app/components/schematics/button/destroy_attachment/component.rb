# frozen_string_literal: true

module Schematics
  module Button
    module DestroyAttachment
      class Component < ApplicationComponent
        delegate :id, :name, to: :@attachment
        delegate :attributes_param_key, to: :field

        def initialize(resource:, attachment:)
          super
          @resource = resource
          @attachment = attachment
        end

        def render?
          @resource && can?(:destroy, @attachment)
        end

        def field
          @resource
            .class
            .entity
            .find_field_by_name(name)
        end
      end
    end
  end
end
