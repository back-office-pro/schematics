# frozen_string_literal: true

module Chartkick
  module Override
    def options
      @options.transform_values { _1.try(:call) || _1 }
    end
  end
end
