# frozen_string_literal: true

require 'active_model/validations/comparability'
require 'active_support/core_ext/time/zones'
require 'active_support/time'

module Schematics
  module Attributes
    class Date < Attribute
      include Behaviours::Migratable
      include Behaviours::Indexable
      include Behaviours::Listable
      include Behaviours::Renderable
      include Behaviours::Searchable
      include Behaviours::Fillable
      include Behaviours::Rangeable

      delegate :start_date?, :end_date?, to: :options

      def available_options = super.push(
        Options::GreaterThan.new(collection:),
        Options::GreaterThanOrEqualTo.new(collection:),
        Options::EqualTo.new(collection:),
        Options::LessThan.new(collection:),
        Options::LessThanOrEqualTo.new(collection:),
        Options::OtherThan.new(collection:),
        Options::StartDate,
        Options::EndDate
      )

      def open_api_schema_type = 'date'

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
          .tap { it.merge!(allow_blank:) if it.any? }
      )

      def default = ::Time
        .current
        .then_tap { it.tomorrow if options.greater_than || options.greater_than_or_equal_to }
        .to_fs(:db)

      def openai_description = 'An attribute which represents a date without time'

      protected

      def collection = entity
        .date_attributes
        .map(&:name)
    end
  end
end
