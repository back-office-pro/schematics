# frozen_string_literal: true

require 'active_support/core_ext/time/zones'
require 'active_model/validations/comparability'

module Schematics
  module Attributes
    class Date < Attribute
      include Behaviours::Listable
      include Behaviours::Renderable
      include Behaviours::Searchable
      include Behaviours::Fillable
      include Behaviours::Rangeable

      def available_options = super.concat(
        ::ActiveModel::Validations::Comparability::COMPARE_CHECKS.keys
      )

      def open_api_type = ::Date

      def group_method = :group_by_day

      def icon = :calendar_days

      def to_sql = super
        .split('/')
        .first

      def format(value)
        value && localize(value, format: :short)
      end

      def validators = super.merge(
        comparison: options
                    .slice(*::ActiveModel::Validations::Comparability::COMPARE_CHECKS.keys)
                    .to_h
                    .transform_values(&:to_sym)
                    .tap { _1.merge!(allow_blank:) if _1.any? }
      )

      def default
        return ::Time.current.tomorrow.to_fs(:db) if options.greater_than

        ::Time.current.to_fs(:db)
      end
    end
  end
end
