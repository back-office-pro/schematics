# frozen_string_literal: true

module Schematics
  module Virtuals
    class Calculation < Virtual
      include Behaviours::Rangeable
      include Behaviours::Numerable

      def open_api_type = ::Float
      def icon = :square_root_alt

      def to_sql
        super.join
      end
    end
  end
end
