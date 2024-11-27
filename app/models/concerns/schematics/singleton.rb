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

    def cache_key = model_name.singular
  end
end
