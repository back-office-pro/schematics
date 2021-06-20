# frozen_string_literal: true

require 'schematics/tokens/tokenizer'
require 'schematics/behaviours/listable'
require 'schematics/behaviours/renderable'
require 'schematics/behaviours/searchable'
require 'schematics/behaviours/preloadable'
require 'array'

module Schematics
  module Virtuals
    class Virtual
      include Behaviours::Listable
      include Behaviours::Renderable
      include Behaviours::Searchable
      include Behaviours::Preloadable

      attr_reader :entity, :name, :options

      class << self
        def create(entity, name:, function:, options: {})
          tokens = Tokens::Tokenizer.tokenize(function, entity.name.pluralize)
          if tokens.any_is_a?(Tokens::Comparator)
            Comparison.new(entity, name, tokens, options)
          elsif tokens.any_is_a?(Tokens::Operator)
            Calculation.new(entity, name, tokens, options)
          else
            Concatenation.new(entity, name, tokens, options)
          end
        end
      end

      def initialize(entity, name, tokens, options)
        @entity = entity
        @name = name
        @tokens = tokens
        @options = options
      end

      def function
        @tokens.map(&:value).join
      end

      def to_sql
        @tokens.map(&:to_sql)
      end

      def preload
        @tokens
          .select_is_a?(Tokens::Variable)
          .flat_map(&:references)
          .uniq
          .map(&:to_sym)
      end

      def to_str
        <<~RUBY
          def #{@name}
            #{function}
          rescue StandardError => e
            e
          end
        RUBY
      end

      def format(value)
        case value
        when NameError
          I18n.t('errors.virtuals.name', name: value.name)
        when TypeError
          I18n.t('errors.virtuals.type', message: value.message)
        when NoMethodError
          I18n.t('errors.virtuals.no_method', name: value.name)
        else
          value
        end
      end

      def weight
        1
      end
    end
  end
end
