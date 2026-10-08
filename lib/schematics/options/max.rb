# frozen_string_literal: true

module Schematics
  module Options
    class Max < Option
      class << self
        def input_type = :number

        def min = 0

        def openai_description = 'The maximum number of attachments'
      end
    end
  end
end
