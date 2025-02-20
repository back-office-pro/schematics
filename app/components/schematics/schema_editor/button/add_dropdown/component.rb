# Copyright © 2025 Dev & Software. All rights reserved.
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
          ].sort_by { it.model_name.human }

          def advanced_collection = Attributes::Attribute
            .collection
            .excluding(
              Attributes::BelongsTo,
              Attributes::User,
              most_used_collection
            )
            .sort_by { it.model_name.human }

          def title = t('.title')

          def entity = builder.object
        end
      end
    end
  end
end
