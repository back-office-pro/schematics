# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'active_model'

module ActiveModel
  module Validations
    class AssociatedValidator < ActiveModel::EachValidator
      def validate_each(record, attribute, value)
        return if Array(value).reject(&:valid?).none?

        record.errors.add(attribute, :invalid, **options, value:)
      end
    end

    module ClassMethods
      def validates_associated(*attr_names)
        validates_with AssociatedValidator, _merge_attributes(attr_names)
      end
    end
  end
end
