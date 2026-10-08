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
        Options::Separator,
        Options::Delimiter
      )

      def database_type = 'float'

      def default = super.to_f

      def openai_description = 'An attribute which represents a float number'

      def open_api_schema_type = 'float'
    end
  end
end
