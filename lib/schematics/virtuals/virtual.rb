module Schematics
  module Virtuals
    class Virtual
      attr_accessor :name

      def initialize(entity, name, tokens)
        @entity = entity
        @name = name
        @tokens = tokens
      end
      
      def parse
        @tokens.map(&:parsed_value).join.taint
      end

      def concat
        @tokens.map(&:concatenated_value).join(", ")
      end

      def scope
        %Q[scope :by_#{@name}, -> ]
      end

      def has_scope
        %Q[has_scope :by_#{@name}, only: :index]
      end

      def to_str
        <<-RUBY
          def #{@name}
            begin
              #{parse}
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
