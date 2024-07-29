# frozen_string_literal: true

module Schematics
  module Attributes
    class Float < Attribute
      include Behaviours::Migratable
      include Behaviours::Indexable
      include Behaviours::Listable
      include Behaviours::Renderable
      include Behaviours::Searchable
      include Behaviours::Fillable
      include Behaviours::Rangeable
      include Behaviours::Numerable
      include Behaviours::Incrementable

      def available_options = super.push(
        Options::Unit,
        Options::Precision,
        Options::Separator
      )

      def database_type = 'float'

      def default = 1.5

      def open_api_type = ::Float
    end
  end
end
