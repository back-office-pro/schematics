# frozen_string_literal: true

class Object
  def then_tap(&)
    self.then(&) || self
  end
end
