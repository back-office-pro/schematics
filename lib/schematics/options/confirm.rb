# frozen_string_literal: true

module Schematics
  module Options
    class Confirm < Option
      class << self
        def input_type = :boolean

        def openai_description = 'Has the password to be confirmed or not'
      end
    end
  end
end
