# frozen_string_literal: true

module Schematics
  module Options
    class LessThanOrEqualTo < CollectionOption
      class << self
        def input_type = :integer
      end
    end
  end
end
