module Schematics
  module Virtuals
    class Virtual
      include Behaviours::Renderable
      include Behaviours::Filterable
      include Behaviours::Sortable
      include Behaviours::Preloadable

      attr_reader :entity, :name

      class << self
        def create(entity, name:, function:, options: {})
          tokens = Tokens::Tokenizer.tokenize(function, entity.type.pluralize)
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

      def includes
        @tokens.select_is_a?(Tokens::Reference).map do |reference|
          reference.value.split('.')[0...-1].map(&:to_sym)
        end.flatten.uniq
      end

      def default_scope
        if includes.any?
          <<~RUBY
            default_scope { joins(#{includes}) }
          RUBY
        end
      end

      def to_str
        <<~RUBY
          def #{@name}
            #{function}
          rescue NameError => e
            Schematics::Virtuals::Errors::NameError.new(e.message, e.name)
          rescue TypeError => e
            Schematics::Virtuals::Errors::TypeError.new(e.message)
          end

          ransacker :#{name} do
            Arel.sql("#{to_sql}")
          end
        RUBY
      end
    end
  end
end
