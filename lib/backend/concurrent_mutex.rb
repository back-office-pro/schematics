# frozen_string_literal: true

module Backend
  class ConcurrentMutex
    def synchronize(&)
      yield
    end
  end
end
