# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

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
      include Behaviours::Duplicable

      attr_accessor :id, :entity, :function

      validates :function,
                presence: true,
                format: { with: Tokens::Tokenizer.parser, message: :function }
      validates :name, uniqueness: { scope: %i[entity nameable_fields] }
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
