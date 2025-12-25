# Copyright © 2025 Dev & Software. All rights reserved.
#
# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

module OpenAPI
  module Paths
    class Index < Path
      protected

      alias path root_path
      alias summary_slug tag

      def http_method = :get

      def default_parameters = [
        Components::Parameter.new(
          name: 'page',
          type: 'integer',
          in: 'query',
          description: translate('open_api.parameters.page')
        ),
        Components::Parameter.new(
          name: 'limit',
          type: 'integer',
          in: 'query',
          description: translate('open_api.parameters.limit')
        ),
        Components::Parameter.new(
          name: 'sort',
          type: 'string',
          in: 'query',
          description: translate('open_api.parameters.sort')
        ),
        Components::Parameter.new(
          name: "#{Ransack.options[:search_key]}[with_deleted]",
          type: 'boolean',
          in: 'query',
          description: translate('open_api.parameters.with_deleted')
        )
      ]

      def responses = [
        Components::Response.not_authorized,
        Components::Response.forbidden,
        Components::Response.new(
          code: 200,
          description: translate('open_api.responses.success'),
          data: [open_api_schema],
          headers: [
            Components::Header.new(
              name: 'current-page',
              type: 'integer',
              description: translate('open_api.headers.current_page')
            ),
            Components::Header.new(
              name: 'page-items',
              type: 'integer',
              description: translate('open_api.headers.page_items')
            ),
            Components::Header.new(
              name: 'total-count',
              type: 'integer',
              description: translate('open_api.headers.total_count')
            ),
            Components::Header.new(
              name: 'total-pages',
              type: 'integer',
              description: translate('open_api.headers.total_pages')
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
            description: translate('open_api.parameters.filter_by', element: element.name)
          )
        end
      end
    end
  end
end
