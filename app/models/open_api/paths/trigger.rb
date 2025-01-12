# frozen_string_literal: true

module OpenAPI
  module Paths
    # :reek:Attribute
    class Trigger < Path
      attr_accessor :event

      protected

      def path = [
        root_path,
        ('{id}' unless singleton?),
        event.state_machine_name,
        event.name
      ].compact.join('/')

      def http_method = :patch

      def summary = [event.human, model_class.human_name].join(' ')

      def operation_id = [class_name, event.name.capitalize].join('_')

      def parameters = super.push(
        (Components::Parameter.id unless singleton?)
      )

      def responses = [
        Components::Response.new(code: 204, description: 'Success'),
        Components::Response.not_authorized,
        Components::Response.forbidden,
        Components::Response.not_found,
        Components::Response.method_not_allowed
      ]
    end
  end
end
