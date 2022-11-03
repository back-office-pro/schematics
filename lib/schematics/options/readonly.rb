# frozen_string_literal: true

module Schematics
  module Options
    class Readonly < Option
      class << self
        def input_type = :boolean
      end
    end
  end
end
