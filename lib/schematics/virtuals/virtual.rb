# frozen_string_literal: true

module Schematics
  # :reek:Attribute :reek:InstanceVariableAssumption
  module Virtuals
    class Virtual
      include Behaviours::Inspectable
      include Behaviours::Optionable
      include Behaviours::Nameable
      include Behaviours::Listable
      include Behaviours::Renderable
      include Behaviours::Searchable
      include Behaviours::Preloadable

      attr_accessor :id, :entity, :function

      validates :function,
                presence: true,
                format: { with: Tokens::Tokenizer.parser, message: :function }
      validates :name, uniqueness: { scope: %i[entity virtuals] }
      validates :preload, inclusion: { in: :allowed_references }
      validates :variables, inclusion: { in: :allowed_variables }
      validate :assignment_token?

      class << self
        def build(**)
          klass(**).new(**)
        end

        def to_proc = -> { build(**_1) }

        def klass(entity:, function:, **)
          tokens = Tokens::Tokenizer.tokenize(function, entity.table_name.pluralize)
          return Comparison  if tokens.any?(Tokens::Comparator)
          return Calculation if tokens.any?(Tokens::Operator)

          Concatenation
        end
      end

      def format(value)
        case value
        when NoMethodError
          value.original_message
        else
          super
        end
      end

      def open_api_type = ::String

      def preload = tokens
        .grep(Tokens::Variable)
        .flat_map(&:references)
        .uniq
        .map(&:to_sym)

      def to_sql
        tokens.map(&:to_sql)
      end

      def search_alias = <<~RUBY
        ransacker :#{name} do
          Arel.sql("#{to_sql}")
        end
      RUBY

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

      def allowed_references = entity
        .association_attributes
        .concat(entity.associations)
        .map(&:name)
        .map(&:to_sym)

      def variables = tokens
        .grep(Tokens::Variable)
        .reject(&:with_references?)
        .map(&:raw_value)

      def allowed_variables = entity
        .renderable_elements
        .map(&:name)

      def assignment_token?
        errors.add(:function, :assignment) if tokens.any?(Tokens::Assignment)
      end

      memoize def tokens = Tokens::Tokenizer.tokenize(function, entity.table_name.pluralize)
    end
  end
end
