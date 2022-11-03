# frozen_string_literal: true

module Schematics
  module Options
    class Events < Option
      class << self
        def input_type = :schema_editor_options_events
      end
    end
  end
end
