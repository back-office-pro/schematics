# frozen_string_literal: true

module Schematics
  module Attributes
    class Jsonb < Attribute
      include Behaviours::Migratable
      include Behaviours::Indexable
      include Behaviours::Fillable
      include Behaviours::Renderable
      include Behaviours::Encryptable

      def database_type = 'json'

      def database_index_type = :gin

      def default = {}

      def icon = :table

      def open_api_schema_type = {}

      def permitted_params = { super => {} }
    end
  end
end
