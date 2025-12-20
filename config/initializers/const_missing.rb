# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

def Object.const_missing(name)
  Schematics::ApplicationRecord.load!(name) || super
end
