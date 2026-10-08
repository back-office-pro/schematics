# frozen_string_literal: true

module Schematics
  module Options
    class Size < Option
      class << self
        def input_type = :number

        def min = 0

        def openai_description = 'The maximum size of the attachment in megabytes'
      end
    end
  end
end
