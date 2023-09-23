# frozen_string_literal: true

class UniquenessWithDeletedValidator < Mobility::Plugins::ActiveRecord::UniquenessValidation::UniquenessValidator # rubocop:disable Layout/LineLength
  def initialize(options)
    super(options.merge(conditions: -> { with_deleted }))
  end
end
