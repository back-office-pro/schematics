# frozen_string_literal: true

module Schematics
  module ForwardModal
    class Component < ApplicationComponent
      option :resource

      def url = polymorphic_path([resource, :forwardings], format: nil)

      def model = ::Message.new

      def method = :post

      def scope = :forwarding

      def layout = :inline

      def field = Associations::Association.build(
        type: 'has_and_belongs_to_many',
        entity: resource.class.entity,
        name: 'recipients',
        options: { type: 'user' }
      )
    end
  end
end
