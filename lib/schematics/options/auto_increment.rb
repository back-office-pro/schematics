# frozen_string_literal: true

module Schematics
  module Options
    class AutoIncrement < Option
      class << self
        def input_type = :boolean

        def openai_description = 'Is the number auto incrementable or not'
      end
    end
  end
end
