# frozen_string_literal: true

module Schematics
  module Virtuals
    class Virtual
      include Behaviours::Listable
      include Behaviours::Renderable
      include Behaviours::Searchable
      include Behaviours::Preloadable

      delegate :hidden?, to: :options
      attr_reader :entity, :name, :options

      TYPE_ERROR_REGEX = /([A-Z][a-z]+)/

      class << self
        def build(entity, name:, function:, options: {})
          tokens = Tokens::Tokenizer.tokenize(function, entity.table_name.pluralize)
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
        @options = Attributes::Options.new(options)
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
        when NoMethodError
          return I18n.t('errors.virtuals.nil') if value.receiver.nil?

          I18n.t('errors.virtuals.no_method', name: value.name.to_s.chomp('_formatted'))
        when NameError
          I18n.t('errors.virtuals.name', variable: value.name)
        when TypeError
          source, target = value.message.scan(TYPE_ERROR_REGEX).flatten
          I18n.t('errors.virtuals.type', source: source, target: target)
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
