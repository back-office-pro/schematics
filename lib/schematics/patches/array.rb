class Array
  def select_is_a?(klass)
    select { |x| x.is_a?(klass) }
  end

  def any_is_a?(klass)
    any? { |x| x.is_a?(klass) }
  end

  def reject_is_a?(klass)
    reject { |x| x.is_a?(klass) }
  end

  def self.unwrap(object)
    [object].flatten.first
  end
end
