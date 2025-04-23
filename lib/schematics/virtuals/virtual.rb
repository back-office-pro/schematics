# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  # :reek:Attribute :reek:InstanceVariableAssumption
  module Virtuals
    class Virtual
      include Behaviours::Specifiable
      include Behaviours::Inspectable
      include Behaviours::Optionable
      include Behaviours::Nameable
      include Behaviours::Listable
      include Behaviours::Renderable
      include Behaviours::Searchable
      include Behaviours::Preloadable
      include Behaviours::Documentable
      include Behaviours::Internationalizable

      attr_accessor :id, :entity, :function

      validates :function,
                presence: true,
                format: { with: Tokens::Tokenizer.parser, message: :function }
      validates :name, uniqueness: { scope: %i[entity fields] }
      validates :preload, inclusion: { in: :allowed_references }
      validates :variables, inclusion: { in: :allowed_variables }
      validate :tokens_cannot_have_assignment

      class << self
        def build(**)
          klass(**).new(**)
        end

        def to_proc = -> { build(**_1) }

        def klass(entity:, function:, **)
          tokens = Tokens::Tokenizer.tokenize(function, entity.table_name.pluralize)
          return Concatenation if tokens.any?(Tokens::String)
          return Comparison if tokens.any?(Tokens::Comparator)

          Calculation
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

      def preload = tokens
        .grep(Behaviours::Preloadable)
        .flat_map(&:references)
        .compact
        .uniq
        .map(&:to_sym)

      def to_sql = "(#{tokens.map(&:to_sql).join(to_sql_separator)})"

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
          Triggers::Errors::StandardError.build(e)
        end
      RUBY

      def weight = 1

      protected

      def tokens_cannot_have_assignment
        errors.add(:function, :assignment) if tokens.any?(Tokens::Assignment)
      end

      def to_sql_separator = nil

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

      def variable_method = nil

      memoize def tokens = Tokens::Tokenizer.tokenize(
        function,
        entity.table_name.pluralize,
        variable_method
      )

      def spec_interpolations = super.merge(name:, function:)
    end
  end
end
