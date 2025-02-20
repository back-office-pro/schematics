# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Template
      module Attribute
        class Component < Template::Component
          with_collection_parameter :constant

          class << self
            def belongs_to_has_one(form:)
              new(
                form:,
                constant: Attributes::BelongsTo,
                options: { inverse_association_type: 'has_one' },
                slug: 'belongs-to-has-one'
              )
            end
          end

          def initialize(form:, constant:, options: nil, slug: nil)
            super
            @form = form
            @constant = constant
            @options = options
            @slug = slug || @constant.type.dasherize
          end

          def attribute = @constant.new(
            id: 'RANDOM_UUID',
            entity:,
            options: @options
          )
        end
      end
    end
  end
end
