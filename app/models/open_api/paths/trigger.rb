# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module OpenAPI
  module Paths
    # :reek:Attribute
    class Trigger < Path
      attr_accessor :event

      protected

      def path = File.join(root_path, '{id}', event.state_machine_name, event.name)

      def http_method = :patch

      def summary = [event.human, human_name].join(' ')

      def operation_id = [class_name, event.name.capitalize].join('_')

      def parameters = super.push(Components::Parameter.id)

      def responses = [
        Components::Response.new(
          code: 204,
          description: translate('open_api.responses.success')
        ),
        Components::Response.not_authorized,
        Components::Response.forbidden,
        Components::Response.not_found,
        Components::Response.method_not_allowed
      ]
    end
  end
end
