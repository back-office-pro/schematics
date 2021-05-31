# frozen_string_literal: true

class Array
  def select_is_a?(*klasses)
    select { |x| klasses.any? { |klass| x.is_a?(klass) } }
  end

  def any_is_a?(*klasses)
    any? { |x| klasses.any? { |klass| x.is_a?(klass) } }
  end

  def reject_is_a?(*klasses)
    reject { |x| klasses.any? { |klass| x.is_a?(klass) } }
  end

  def stable_sort_by
    sort_by.with_index { |x, idx| [yield(x), idx] }
  end
end
