module Schematics
  module Virtuals
    class Virtual
      include Renderable
      
      attr_accessor :name

      def initialize(entity, name, tokens, options = nil)
        @entity = entity
        @name = name
        @tokens = tokens
        @options = options || {}
      end
      
      def function
        @tokens.map(&:value).join.taint
      end

      def to_sql
        @tokens.map(&:to_sql)
      end

      def column_definition
        "#{to_sql} AS #{@name}"
      end

      def joins
        @tokens.select_is_a?(Tokens::Reference).map do |reference|
          reference.value.split('.')[0...-1].map { |value| value.prepend(':') }
        end.flatten.uniq.join(', ')
      end

      def filter_scope
        %Q[scope :by_#{@name}, -> ]
      end

      def sort_scope
        if joins.empty?
          %Q[scope :sort_by_#{@name}, -> sort_direction { order({ Arel.sql("#{to_sql}") => sort_direction }) }]
        else
          %Q[scope :sort_by_#{@name}, -> sort_direction { joins(#{joins}).order({ Arel.sql("#{to_sql}") => sort_direction }) }]
        end
      end

      def has_filter_scope
        %Q[has_scope :by_#{@name}, only: :index]
      end

      def has_sort_scope
        %Q[has_scope :sort_by_#{@name}, only: :index]
      end

      def to_str
        <<-RUBY
          def #{@name}
            begin
              #{function}
            rescue NameError => e
              "SchemaError: \#{e.name\} not defined"
            rescue TypeError => e
              "SchemaError: \#{e.message\}"
            end
          end
        RUBY
      end
    end
  end
end
