# frozen_string_literal: true

module Schematics
  # :reek:Attribute :reek:InstanceVariableAssumption
  module Virtuals
    class Virtual
      include Behaviours::Inspectable
      include Behaviours::Listable
      include Behaviours::Renderable
      include Behaviours::Searchable
      include Behaviours::Preloadable
      include ::ActiveModel::API

      delegate :hidden?, to: :options
      attr_accessor :entity, :name, :function
      attr_writer :options

      validates :function, presence: true
      validates :name,
                presence: true,
                format: { with: /\A(\w+)\z/, message: :name },
                length: { maximum: 50 },
                exclusion: { in: :dangerous_attribute_methods }

      class << self
        def build(**kwargs)
          klass(**kwargs).new(**kwargs)
        end

        def klass(entity:, function:, **_kwargs)
          tokens = Tokens::Tokenizer.tokenize(function, entity.table_name.pluralize)

          return Malformed   if tokens.any?(Tokens::Assignment)
          return Comparison  if tokens.any?(Tokens::Comparator) # rubocop:disable Lint/ConstantResolution
          return Calculation if tokens.any?(Tokens::Operator)

          Concatenation
        end
      end

      alias options_attributes= options=

      def available_options = []

      def format(value)
        case value
        when NoMethodError
          value.original_message
        else
          super
        end
      end

      def open_api_type = ::String

      def options
        Schematics::Options.new(options: @options)
      end

      def preload = tokens
        .select_is_a?(Tokens::Variable)
        .flat_map(&:references)
        .uniq
        .map(&:to_sym)

      def to_sql
        tokens.map(&:to_sql)
      end

      def to_str = <<~RUBY
        define_attribute_method :#{name}
        def #{name}
          #{method_body}
        rescue StandardError => e
          e.exception(Virtuals::Errors.const_get(e.class.to_s).new(e))
        end
      RUBY

      def weight = 1

      protected

      def method_body = tokens
        .map(&:value)
        .join

      def tokens
        @tokens ||= Tokens::Tokenizer.tokenize(function, entity.table_name.pluralize)
      end
    end
  end
end
