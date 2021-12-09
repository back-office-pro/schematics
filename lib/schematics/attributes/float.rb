# frozen_string_literal: true

module Schematics
  module Attributes
    class Float < Attribute
      include Behaviours::Listable
      include Behaviours::Renderable
      include Behaviours::Searchable
      include Behaviours::Fillable
      include Behaviours::Rangeable
      include Behaviours::Numerable

      def type
        'float'
      end
    end
  end
end
