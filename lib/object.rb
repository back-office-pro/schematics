# frozen_string_literal: true

require 'memery'

class Object
  include Memery

  def then_tap(&) = self.then(&) || self
end
