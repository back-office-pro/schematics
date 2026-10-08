# frozen_string_literal: true

module Schematics
  module Reloadable
    extend ActiveSupport::Concern

    included do
      prepend_before_action :reload!
    end

    private

    def reload! # rubocop:disable Metrics/CyclomaticComplexity
      old_and_changed_model_classes = Rails.cache.read('old_and_changed_model_classes')
      return unless old_and_changed_model_classes

      Rails.cache.delete('old_and_changed_model_classes')
      old_and_changed_model_classes
        .select(&Object.method(:const_defined?))
        .each(&Object.method(:remove_const))
      old_and_changed_model_classes
        .filter_map(&:safe_constantize)
        .each(&:reset_column_information)
      old_and_changed_model_classes
        .filter_map(&:safe_constantize)
        .each(&:define_attribute_methods)
    end
  end
end
