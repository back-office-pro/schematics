# frozen_string_literal: true

class Object
  def then_tap(&block)
    self.then(&block) || self
  end
end
