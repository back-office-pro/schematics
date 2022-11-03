# frozen_string_literal: true

module Schematics
  module Options
    class Default < Option
      class << self
        def input_type = :string
      end
    end
  end
end
