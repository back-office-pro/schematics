# frozen_string_literal: true

module Schematics
  module Options
    class Delimiter < Separator
      class << self
        def openai_description = 'The number thousands separator'
      end
    end
  end
end
