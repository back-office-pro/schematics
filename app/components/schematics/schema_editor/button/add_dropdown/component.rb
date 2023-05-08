# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Button
      module AddDropdown
        class Component < ApplicationComponent
          delegate :index, to: :builder
          option :builder

          def most_used_collection = [
            Attributes::Attachment,
            Attributes::Boolean,
            Attributes::Date,
            Attributes::StateMachine,
            Attributes::Integer,
            Attributes::String,
            Attributes::Text
          ].sort_by { _1.model_name.human }

          def unused_collection = [
            Attributes::Action,
            Attributes::Model,
            Attributes::ModelField,
            Attributes::Uuid,
            Attributes::Locale,
            Attributes::Timestamp
          ]

          def advanced_collection = Attributes
            .constants
            .excluding(SchemaEditor::Component::DENYLIST)
            .map(&Attributes.method(:const_get))
            .excluding(
              Attributes::BelongsTo,
              Attributes::References,
              most_used_collection,
              unused_collection
            )
            .sort_by { _1.model_name.human }

          def title = t('.title')

          def entity = builder.object
        end
      end
    end
  end
end
