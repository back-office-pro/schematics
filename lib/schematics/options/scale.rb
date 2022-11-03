# frozen_string_literal: true

module Schematics
  module Options
    class Scale < Option
      class << self
        def input_type = :integer
      end
    end
  end
end
