# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'active_model'

class SingularValidator < ActiveModel::EachValidator
  # :reek:UtilityFunction
  def validate_each(record, attribute, value)
    return if value.singularize == record.name

    record.errors.add(attribute, :singular)
  end
end
