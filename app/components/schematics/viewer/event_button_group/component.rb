# frozen_string_literal: true

module Schematics
  module Viewer
    module EventButtonGroup
      class Component < ApplicationComponent
        option :resource
        option :compact, default: -> { true }

        def events = resource
          .class
          .entity
          .events
          .select { |event| can?(event.name.to_sym, resource) }
          .select { |event| resource.public_send(:"may_#{event.suffixed_name}?") }
      end
    end
  end
end
