# frozen_string_literal: true

module Schematics
  module Attributes
    class BelongsTo < Association
      include Behaviours::Fillable
    end
  end
end
