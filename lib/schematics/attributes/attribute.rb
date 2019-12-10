module Schematics
  module Attributes
    class Attribute
      attr_accessor :entity, :name, :renderer

      def initialize(entity, name, options = nil, renderer = nil)
        @entity = entity 
        @name = name
        @options = options || {}
        @renderer = Renderers::Factory.create_custom(self, renderer || {})
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

      def model_property_type
        type
      end

      def api_param_type
        type
      end

      def model_property
        %Q[property :#{@name.camelize(:lower)}, :#{model_property_type}, #{(unique? || required?) ? ":required" : ":optional"}, "#{@name.humanize}"]
      end

      def api_param
        %Q[param :form, "#{@entity.type.camelize(:lower)}[#{@name.camelize(:lower)}]", :#{api_param_type}, #{(unique? || required?) ? ":required" : ":optional"}, "#{@name.humanize}"]
      end

      def validators
        validators = {}
        validators[:uniqueness] = { case_sensitive: false, allow_blank: !required? } if unique?
        validators[:presence] = true if required?
        validators
      end

      def scope
        %Q[scope :by_#{@name}, -> ]
      end

      def has_scope
        %Q[has_scope :by_#{@name}, only: :index]
      end

      def validate
        %Q[validates :#{@name}, #{validators.to_s[1...-1]}] unless validators.empty?
      end

      def to_str
        ""
      end
    end
  end
end
