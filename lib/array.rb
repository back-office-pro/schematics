# frozen_string_literal: true

class Array
  def avg = sum.fdiv(size)

  def stable_sort_by
    sort_by.with_index { [yield(_1), _2] } # rubocop:disable Style/NumberedParametersLimit
  end
end
