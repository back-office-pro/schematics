module Schematics
  module Attributes
    class Attribute
      include Renderable
      attr_accessor :entity, :name

      class << self
        def create(entity, name:, type:, options: {})
          klass = "Schematics::Attributes::#{type.underscore.camelize}".constantize
          klass.new(entity, name, options)
        end
      end

      def initialize(entity, name, options)
        @entity = entity
        @name = name
        @options = options || {}
      end

      def type
        self.class.name.demodulize.underscore
      end

      def migration_options
        [:unique, :required, :default]
      end

      def to_s
        [@name, type, @options.slice(*migration_options).to_a].reject(&:empty?).join(':')
      end

      def required?
        @options[:required]
      end

      def unique?
        @options[:unique]
      end

      def column_name
        @name
      end

      def permitted_param
        column_name
      end

      def permitted_json_param
        permitted_param
      end

      def model_property_type
        api_param_type
      end

      def api_param_type
        type
      end

      def model_property
        <<~RUBY
          property :#{@name.camelize(:lower)},
                   :#{model_property_type},
                   #{(unique? || required?) ? ":required" : ":optional"},
                   "#{@name.humanize}"
        RUBY
      end

      def api_param
        <<~RUBY
          param :form,
          "#{@entity.type.camelize(:lower)}[#{@name.camelize(:lower)}]",
          :#{api_param_type},
          #{(unique? || required?) ? ":required" : ":optional"},
          "#{@name.humanize}"
        RUBY
      end

      def validators
        validators = {}
        validators[:uniqueness] = { case_sensitive: false, allow_blank: !required? } if unique?
        validators[:presence] = true if required?
        validators
      end

      def filter_scope
        <<~RUBY
          scope :by_#{@name}, ->
        RUBY
      end

      def sort_scope
        <<~RUBY
          scope :sort_by_#{@name}, ->
        RUBY
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

      def validate
        unless validators.empty?
          <<~RUBY
            validates :#{@name}, #{validators.to_s[1...-1]}
          RUBY
        end
      end

      def default
        SecureRandom.base58 if unique?
      end

      def json_default
        default
      end

      def to_str
        ""
      end
    end
  end
end
