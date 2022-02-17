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
          define_attribute_method :#{@name}
          def #{@name}
            #{function}
          rescue StandardError => e
            e.exception(Virtuals::Errors.const_get(e.class.to_s).new(e))
          end
        RUBY
      end

      def weight
        1
      end
    end
  end
end
