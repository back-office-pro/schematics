# frozen_string_literal: true

module Schematics
  module Options
    class Polymorphic < Option
      class << self
        def hidden? = true

        def input_type = :boolean
      end
    end
  end
end
