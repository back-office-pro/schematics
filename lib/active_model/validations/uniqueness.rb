# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'active_model'

module ActiveModel
  module Validations
    class UniquenessValidator < ActiveModel::EachValidator
      def validate_each(record, attribute, value)
        return if Array(options[:scope])
                  .reduce(record, :public_send)
                  .excluding(record)
                  .map(&attribute)
                  .exclude?(value)

        record.errors.add(attribute, :taken, **options.except(:scope), value:)
      end
    end

    module ClassMethods
      def validates_uniqueness_of(*attr_names)
        validates_with UniquenessValidator, _merge_attributes(attr_names)
      end
    end
  end
end
