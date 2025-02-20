# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'memery'

class Object
  include Memery

  def then_tap(&) = self.then(&) || self
end
