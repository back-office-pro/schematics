module Schematics
  module Attributes
    class Attribute
      attr_reader :entity, :name

      class << self
        def create(entity, name:, type:, options: {})
          Attributes.const_get(type.camelize.to_sym).new(entity, name, options)
        end

        def created_at(entity)
          create(entity, type: 'date', name: 'created_at')
        end

        def id(entity)
          create(entity, type: 'integer', name: 'id')
        end
      end

      def initialize(entity, name, options)
        @entity = entity
        @name = name
        @options = options
      end

      def type
        self.class.name.demodulize.underscore
      end

      def migration_options
        %i[unique required default]
      end

      def to_s
        [@name, type, @options.slice(*migration_options).to_a].reject(&:empty?).join(':')
      end

      def required?
        @options[:required] || unique?
      end

      def unique?
        @options[:unique]
      end

      def column_name
        @name
      end

      def validators
        validators = {}
        validators[:uniqueness] = { case_sensitive: false } if unique?
        validators[:presence] = true if required?
        validators
      end

      def validate
        return if validators.empty?
        <<~RUBY
          validates :#{@name}, #{validators}
        RUBY
      end

      def to_sql
        [@entity.name.pluralize, @name].join('.')
      end

      def to_str
        ''
      end

      def weight
        1
      end
    end
  end
end
