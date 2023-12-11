# frozen_string_literal: true

module Chartkick
  class << self
    SEMAPHORE = Mutex.new.freeze

    def options
      SEMAPHORE.synchronize do
        @options.transform_values { _1.try(:call) || _1 }
      end
    end
  end
end
