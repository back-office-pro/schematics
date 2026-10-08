# frozen_string_literal: true

module Schematics
  module Options
    class AllowHidden < Option
      class << self
        def hidden? = true

        def input_type = :boolean
      end
    end
  end
end
