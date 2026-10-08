# frozen_string_literal: true

module Schematics
  module Behaviours
    module Indexable
      def to_s
        return super if unique?

        "#{super}:index"
      end
    end
  end
end
