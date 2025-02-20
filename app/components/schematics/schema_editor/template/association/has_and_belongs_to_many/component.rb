# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Template
      module Association
        module HasAndBelongsToMany
          class Component < Template::Component
            def association = Associations::Association.build(
              type: 'has_and_belongs_to_many',
              entity:,
              name: 'NEW_HABTM_ASSOCIATION'
            )
          end
        end
      end
    end
  end
end
