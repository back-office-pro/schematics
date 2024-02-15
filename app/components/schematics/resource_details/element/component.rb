# frozen_string_literal: true

module Schematics
  module ResourceDetails
    module Element
      class Component < ApplicationComponent
        option :resource
        option :element
        option :editable, default: -> { true }

        def editable?
          enable_buttons? && !(element in Attributes::Attachment)
        end

        def enable_buttons?
          editable &&
            can?(:update, resource, element.name.to_sym) &&
            (element in Behaviours::Fillable) &&
            !element.readonly?
        end
      end
    end
  end
end
