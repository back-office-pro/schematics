require 'schematics/attributes/association'
require 'schematics/behaviours/fillable'

module Schematics
  module Attributes
    class BelongsTo < Association
      include Behaviours::Fillable
    end
  end
end
