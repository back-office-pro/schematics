# frozen_string_literal: true

class Array
  def select_is_a?(*klasses)
    select { |element| klasses.any? { |klass| element.is_a?(klass) } }
  end

  def reject_is_a?(*klasses)
    reject { |element| klasses.any? { |klass| element.is_a?(klass) } }
  end

  def stable_sort_by
    sort_by.with_index { |first_element, second_element| [yield(first_element), second_element] }
  end
end
