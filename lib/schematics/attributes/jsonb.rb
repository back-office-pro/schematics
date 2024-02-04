# frozen_string_literal: true

module Schematics
  module Attributes
    class Jsonb < Attribute
      include Behaviours::Migratable
      include Behaviours::Fillable
      include Behaviours::Renderable
      include Behaviours::Encryptable

      def database_index_type = :gin

      def default = {}

      def icon = :table

      def open_api_type = {}

      def permitted_params = { super => {} }

      def language = 'json'
    end
  end
end
