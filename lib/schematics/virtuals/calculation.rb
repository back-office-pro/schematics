# frozen_string_literal: true

module Schematics
  module Virtuals
    class Calculation < Virtual
      include Behaviours::Rangeable
      include Behaviours::Numerable

      def open_api_type
        ::Float
      end

      def to_sql
        super.join
      end

      def icon
        :square_root_alt
      end
    end
  end
end
