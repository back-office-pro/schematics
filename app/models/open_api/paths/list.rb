# frozen_string_literal: true

module OpenAPI
  module Paths
    class List < Path
      protected

      alias path root_path

      def http_method = :get

      def summary = super.pluralize

      def default_parameters = [
        Components::Parameter.new(
          name: 'page',
          type: 'integer',
          in: 'query',
          description: 'Page number'
        ),
        Components::Parameter.new(
          name: 'limit',
          type: 'integer',
          in: 'query',
          description: 'Items per page'
        ),
        Components::Parameter.new(
          name: 'sort',
          type: 'string',
          in: 'query',
          description: 'Sort fields list separated by comma'
        ),
        Components::Parameter.new(
          name: "#{Ransack.options[:search_key]}[with_deleted]",
          type: 'boolean',
          in: 'query',
          description: 'Display archives'
        )
      ]

      def responses = [
        Components::Response.not_authorized,
        Components::Response.forbidden,
        Components::Response.new(
          code: 200,
          description: 'Success',
          data: [open_api_schema],
          headers: [
            Components::Header.new(
              name: 'current-page',
              type: 'integer',
              description: 'Current page'
            ),
            Components::Header.new(
              name: 'page-items',
              type: 'integer',
              description: 'Items per page'
            ),
            Components::Header.new(
              name: 'total-count',
              type: 'integer',
              description: 'Total count of items'
            ),
            Components::Header.new(
              name: 'total-pages',
              type: 'integer',
              description: 'Pages count'
            )
          ]
        )
      ]

      def parameters = super
        .concat(default_parameters)
        .concat(search_parameters)

      def search_parameters
        searchable_elements.map do |element|
          Components::Parameter.new(
            name: "#{Ransack.options[:search_key]}[#{element.name}]",
            type: element.open_api_query_type,
            in: 'query',
            description: "Filter by #{element.name}"
          )
        end
      end
    end
  end
end
