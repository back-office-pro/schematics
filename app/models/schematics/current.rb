# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class Current < ActiveSupport::CurrentAttributes
    attribute :mod
    attr_writer :mod
  end
end
