# frozen_string_literal: true

class Object
  include Memery

  def then_tap(&) = self.then(&) || self
end
