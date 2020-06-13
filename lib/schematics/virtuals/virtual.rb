module Schematics
  module Virtuals
    class Virtual
      include Behaviours::Renderable
      include Behaviours::Searchable
      include Behaviours::Preloadable

      attr_reader :entity, :name

      class << self
        def create(entity, name:, function:, options: {})
          tokens = Tokens::Tokenizer.tokenize(function, entity.name.pluralize)
          if tokens.any_is_a?(Tokens::Operator)
            Virtuals::Calculation.new(entity, name, tokens, options)
          else
            Virtuals::Concatenation.new(entity, name, tokens, options)
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
        @tokens.map(&:value).join.taint
      end

      def to_sql
        @tokens.map(&:to_sql)
      end

      def preload
        @tokens.select_is_a?(Tokens::Reference).map do |reference|
          reference.value.split('.')[0...-1].map(&:to_sym)
        end.flatten.uniq
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
    end
  end
end
