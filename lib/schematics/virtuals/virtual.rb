require 'schematics/tokens/tokenizer'
require 'schematics/virtuals/errors/name_error'
require 'schematics/virtuals/errors/type_error'
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

      attr_reader :entity, :name

      class << self
        def create(entity, name:, function:, options: {})
          tokens = Tokens::Tokenizer.tokenize(function, entity.name.pluralize)
          if tokens.any_is_a?(Tokens::Operator)
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
        @tokens.select_is_a?(Tokens::Variable).flat_map(&:references).uniq.map(&:to_sym)
      end

      def to_str
        <<~RUBY
          default_scope { includes(#{preload}) }

          def #{@name}
            #{function}
          rescue NameError => e
            Virtuals::Errors::NameError.new(e.message, e.name)
          rescue TypeError => e
            Virtuals::Errors::TypeError.new(e.message)
          end
        RUBY
      end

      def weight
        1
      end
    end
  end
end
