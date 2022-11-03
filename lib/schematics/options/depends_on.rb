# frozen_string_literal: true

module Schematics
  module Options
    class DependsOn < Option
      class << self
        def input_type = :string
      end
    end
  end
end
