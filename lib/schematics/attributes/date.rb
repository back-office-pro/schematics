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

      def open_api_type = ::Date
      def group_method = :group_by_day
      def icon = :calendar_days

      def to_sql
        super.split('/').first
      end

      def format(value)
        value && localize(value, format: :short)
      end

      def validators
        super.merge(
          comparison: options
                      .slice(*::ActiveModel::Validations::Comparability::COMPARE_CHECKS.keys)
                      .to_h
                      .transform_values(&:to_sym)
                      .tap { _1.merge!(allow_blank:) if _1.any? }
        )
      end

      def default
        return ::Time.zone.today.to_fs(:db) if options.less_than
        return ::Time.zone.tomorrow.to_fs(:db) if options.greater_than
      end

      protected

      def migration_options
        super.concat %i[default]
      end
    end
  end
end
