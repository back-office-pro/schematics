# frozen_string_literal: true

module Schematics
  class ApplicationQuery
    delegate_missing_to :model_class

    class << self
      delegate :call, to: :new
    end

    def call
      raise NotImplementedError
    end

    protected

    def model_class = self
      .class
      .module_parent
      .to_s
      .demodulize
      .constantize
  end
end
