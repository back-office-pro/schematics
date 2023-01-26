# frozen_string_literal: true

module Schematics
  class ApplicationQuery
    delegate_missing_to :model_class
    attr_reader :model_class

    class << self
      delegate :call, to: :new

      def module_class = module_parent
        .to_s
        .delete_prefix('Application')
        .singularize
        .constantize
    end

    def initialize(model_class = self.class.module_class)
      @model_class = model_class
    end

    def call
      raise NotImplementedError
    end
  end
end
