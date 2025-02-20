# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Attribute
      class Component < ApplicationComponent
        delegate :class, to: 'builder.object', prefix: :attribute
        delegate :allowed_association_types, :icon, to: 'builder.object'
        delegate :compatible_types, to: :attribute_class, private: true
        option :builder

        def collection = compatible_types
          .map { [it.model_name.human, it.type] }
          .sort

        def prompt = t('prompt', attribute_name:)

        def title = attribute_class
          .model_name
          .human

        private

        def attribute_name = Attributes::Attribute
          .human_attribute_name('name')
          .downcase
      end
    end
  end
end
