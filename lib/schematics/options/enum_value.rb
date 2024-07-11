# frozen_string_literal: true

module Schematics
  module Options
    # :reek:Attribute
    class EnumValue
      include ::ActiveModel::API
      include Behaviours::Internationalizable

      delegate :entity, :name, to: :enum, private: true

      attr_accessor :enum, :value

      def i18n_key
        [super, value].join('.')
      end

      alias id i18n_key

      private

      def i18n_scope = :enums
    end
  end
end
