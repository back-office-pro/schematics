# frozen_string_literal: true

def Object.const_missing(name)
  Schematics::ApplicationRecord.load!(name) || super
end
