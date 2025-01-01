# frozen_string_literal: true

module Schematics
  module Behaviours
    module Enumerable
      def available_options = super.excluding(
        Options::Min,
        Options::Limit,
        Options::Length,
        Options::CaseInsensitive
      )

      def values = Array(options.values)

      def collection = values.map { [format(it), it] }

      def default = values.first

      def search_predicate = :in

      def validators
        super.merge inclusion: { in: values, allow_blank: }
      end
    end
  end
end
