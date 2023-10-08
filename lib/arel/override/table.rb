# frozen_string_literal: true

# TODO: Remove when https://github.com/activerecord-hackery/ransack/issues/1420 is fixed
module Arel
  class Table
    def table_name = name
  end
end
