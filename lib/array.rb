# frozen_string_literal: true

class Array
  def select_is_a?(*klasses)
    select { |element| klasses.any? { |klass| element.is_a?(klass) } }
  end

  def reject_is_a?(*klasses)
    reject { |element| klasses.any? { |klass| element.is_a?(klass) } }
  end

  def stable_sort_by
    sort_by.with_index { [yield(_1), _2] } # rubocop:disable Style/NumberedParametersLimit
  end
end
