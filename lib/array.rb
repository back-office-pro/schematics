class Array
  def select_is_a?(klass)
    select { _1.is_a?(klass) }
  end

  def any_is_a?(klass)
    any? { _1.is_a?(klass) }
  end

  def reject_is_a?(klass)
    reject { _1.is_a?(klass) }
  end
end
