# frozen_string_literal: true

module Schematics
  module Options
    class Default < Option
      class << self
        def input_type = :polymorphic

        def openai_type = 'string'

        def openai_description = 'Default value of the attribute'
      end
    end
  end
end
