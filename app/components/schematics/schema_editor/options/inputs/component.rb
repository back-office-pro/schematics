# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Options
      module Inputs
        class Component < ApplicationComponent
          delegate :option_name, to: :option

          option :builder
          option :option
          option :object

          class << self
            def build(builder:, option:, object:)
              module_parent
                .const_get(option.input_type.to_s.camelize)::Component
                .new(builder:, option:, object:)
            end
          end

          def include_hidden = false

          def include_blank(name = attribute_name)
            t('prompt', attribute_name: name.downcase.singularize(I18n.locale))
          end

          protected

          def attribute_name(name = option_name)
            Schematics::Options::Wrapper.human_attribute_name(name)
          end
        end
      end
    end
  end
end
