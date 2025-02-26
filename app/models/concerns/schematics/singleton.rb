# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Singleton
    extend ActiveSupport::Concern

    included do
      include ::Singleton
      include Cacheable

      class << self
        public :new, :allocate
        alias_method :instance, :first_or_initialize
      end
    end

    class_methods do
      def route_params = { resource: I18n.t("activerecord.models.#{name.demodulize.underscore}.one").parameterize(separator: '-') }
    end

    def route_params = super.except(:id)

    def cache_key = model_name.singular
  end
end
