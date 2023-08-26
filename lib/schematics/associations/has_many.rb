# frozen_string_literal: true

require 'active_support/core_ext/string/indent'

module Schematics
  module Associations
    class HasMany < Association
      include Behaviours::Fillable

      def permitted_params
        return unless nested?

        {
          attributes_param_key => entity
            .permitted_params
            .excluding(super)
            .push(:id, :_destroy)
        }
      end

      def permitted_json_params
        return unless nested?

        {
          attributes_param_key => entity
            .permitted_json_params
            .excluding(super)
            .push(:id, :destroy)
        }
      end

      def source = super.pluralize

      protected

      def association_to_str = super
        .concat(",\n")
        .concat(association_options)
        .concat(accepts_nested_attributes_for)

      def dependent
        return :destroy if required?

        :nullify
      end

      def attributes_param_key = :"#{name}_attributes"

      def association_options = <<~RUBY.indent(8)
        inverse_of: :#{inverse_of},
        dependent: :#{dependent}
      RUBY

      def accepts_nested_attributes_for
        return '' unless nested?

        <<~RUBY
          accepts_nested_attributes_for :#{name}
        RUBY
      end
    end
  end
end
