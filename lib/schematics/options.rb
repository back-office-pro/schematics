# frozen_string_literal: true

module Schematics
  # :reek:Attribute :reek:InstanceVariableAssumption
  class Options
    include ::ActiveModel::API

    delegate :slice, :fetch, :dig, :key?, to: :options
    attr_writer :options

    def options
      @options || {}
    end

    def method_missing(method_name, *_args, &)
      return dig(method_name) unless method_name.end_with?('?')

      fetch(method_name.to_s.chomp('?').to_sym, false)
    end

    def respond_to_missing?(method_name, *_args)
      key?(method_name.to_s.chomp('?').to_sym)
    end
  end
end
