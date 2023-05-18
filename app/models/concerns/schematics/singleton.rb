# frozen_string_literal: true

module Schematics
  module Singleton
    extend ActiveSupport::Concern

    included do
      include ::Singleton

      class << self
        public :new, :allocate
        alias_method :instance, :first_or_create
      end
    end

    def cache_key = model_name.singular
  end
end
