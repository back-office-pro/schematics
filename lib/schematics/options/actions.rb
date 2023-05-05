# frozen_string_literal: true

module Schematics
  module Options
    # :reek:Attribute :reek:InstanceVariableAssumption
    class Actions < Option
      include ::ActiveModel::API

      attr_writer :collection

      def multiple? = true

      def input_type = :select

      def controller = 'dropdown'

      def collection = @collection
        .map { [I18n.t(_1, scope: %i[activerecord attributes permission actions]), _1] }
        .sort
    end
  end
end
