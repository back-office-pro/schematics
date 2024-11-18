# frozen_string_literal: true

module Schematics
  module ResourceDetails
    module Element
      class Component < ApplicationComponent
        delegate :deleted?, to: :resource, private: true
        delegate :readonly?, to: :element, private: true
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
            !readonly? &&
            !deleted?
        end
      end
    end
  end
end
