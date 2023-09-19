# frozen_string_literal: true

module Schematics
  module Button
    module DestroyAttachment
      class Component < ApplicationComponent
        delegate :name, to: :attachment
        delegate :attributes_param_key, to: :field
        option :resource
        option :attachment

        def field = resource
          .class
          .entity
          .find_field_by_name(name)

        def target = "confirm-dialog-#{resource.id}-#{attachment.id}"

        def title = t('schematics.application.button.destroy')

        def render?
          resource && can?(:destroy, attachment)
        end
      end
    end
  end
end
