module Schematics
  module Virtuals
    class Virtual
      include Renderable
      attr_accessor :name

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

      def joins
        @tokens.select_is_a?(Tokens::Reference).map do |reference|
          reference.value.split('.')[0...-1].map { |value| value.prepend(':') }
        end.flatten.uniq.join(', ')
      end

      def filter_scope
        <<~RUBY
          scope :by_#{@name}, ->
        RUBY
      end

      def sort_scope
        if joins.empty?
          <<~RUBY
            scope :sort_by_#{@name}, -> sort_direction do
              order({ Arel.sql("#{to_sql}") => sort_direction })
            end
          RUBY
        else
          <<~RUBY
            scope :sort_by_#{@name}, -> sort_direction do
              joins(#{joins}).
              order({ Arel.sql("#{to_sql}") => sort_direction })
            end
          RUBY
        end
      end

      def has_filter_scope
        <<~RUBY
          has_scope :by_#{@name}, only: :index
        RUBY
      end

      def has_sort_scope
        <<~RUBY
          has_scope :sort_by_#{@name}, only: :index
        RUBY
      end

      def to_str
        <<~RUBY
          def #{@name}
            begin
              #{function}
            rescue NameError => e
              Virtuals::Errors::NameError.new(e.message, e.name)
            rescue TypeError => e
              Virtuals::Errors::TypeError.new(e.message)
            end
          end
        RUBY
      end
    end
  end
end
