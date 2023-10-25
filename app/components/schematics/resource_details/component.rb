# frozen_string_literal: true

module Schematics
  module ResourceDetails
    class Component < ApplicationComponent
      delegate :entity, to: :model_class
      option :resource
      option :model_class, default: -> { resource.class }
      option :editable, default: -> { false }

      def elements = entity
        .renderable_elements
        .excluding(entity.has_many_and_through_and_belongs_to_many_associations)
        .grep_v(Attributes::RichText)
        .grep_v(Attributes::Attachments)
        .grep_v(Attributes::Uuid)
    end
  end
end
