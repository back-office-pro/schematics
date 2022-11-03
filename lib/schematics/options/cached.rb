# frozen_string_literal: true

module Schematics
  module Options
    class Cached < Option
      class << self
        def input_type = :boolean
      end
    end
  end
end
