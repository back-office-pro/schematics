# frozen_string_literal: true

require 'active_record'

class UniquenessWithDeletedValidator < ActiveRecord::Validations::UniquenessValidator
  def initialize(options)
    super(options.merge(conditions: -> { with_deleted }))
  end
end
