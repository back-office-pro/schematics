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
            Attributes::Enum,
            Attributes::Integer,
            Attributes::String,
            Attributes::Text
          ].sort_by { _1.model_name.human }

          def never_used_collection = [
            Attributes::Action,
            Attributes::Model,
            Attributes::ModelField,
            Attributes::Uuid,
            Attributes::Locale,
            Attributes::Timestamp,
            Attributes::Array
          ]

          def advanced_collection = (Attributes.constants - SchemaEditor::Component::DENYLIST)
            .map(&Attributes.method(:const_get))
            .excluding(Attributes::BelongsTo, most_used_collection, never_used_collection)
            .sort_by { _1.model_name.human }

          def title = t('.title')

          def entity = builder.object
        end
      end
    end
  end
end
