# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Mobility
  module Override
    module Backends
      module ActiveRecord
        module KeyValue
          def define_has_many_association(klass, attributes)
            attrs_method_name = :"__#{association_name}_attributes"
            association_attributes = (klass.instance_variable_get(:"@#{attrs_method_name}") || []) + attributes # rubocop:disable Layout/LineLength
            klass.instance_variable_set(:"@#{attrs_method_name}", association_attributes)
            context = self
            klass.has_many association_name,
                           -> { where(context.key_column => association_attributes) },
                           as: belongs_to,
                           class_name: class_name.name,
                           inverse_of: belongs_to,
                           autosave: true,
                           dependent: :destroy
          end
        end
      end
    end
  end
end
