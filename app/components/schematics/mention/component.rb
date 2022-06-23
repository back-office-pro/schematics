# frozen_string_literal: true

module Schematics
  module Mention
    class Component < ApplicationComponent
      delegate :class, to: :@resource, prefix: :model, private: true
      delegate :entity, to: :model_class, private: true
      delegate :icon, to: :entity

      def initialize(resource:)
        super
        @resource = resource
      end
    end
  end
end
