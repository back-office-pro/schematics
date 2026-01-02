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
  module Associations
    class HasAndBelongsToMany < Association
      include Behaviours::Optionable
      include Behaviours::Validatable
      include Behaviours::Fillable

      delegate :includes, :descriptor, :class_name, :model_class, to: :inverse_entity
      delegate :options, :allowed_association_types, to: :belongs_to

      validates :name,
                presence: true,
                uniqueness: { scope: %i[entity has_and_belongs_to_many_associations] },
                comparison: { other_than: :denied_name, unless: :hidden? }
      validates :association_type, inclusion: { in: :allowed_association_types }

      # :reek:UtilityFunction
      memoize def id = SecureRandom.uuid

      def available_options = [
        Options::Required,
        Options::Hidden,
        Options::Type,
        Options::GroupBy,
        Options::FilterBy
      ]

      def icon
        inverse_entity&.icon || :link
      end

      def column_name = "#{name.singularize}_ids"

      def default = [inverse_entity.default]

      def permitted_params = { super => [] }

      def input_name = "#{super}[]"

      def source = inverse_of.pluralize

      def open_api_body_type = %w[string]

      def inverse_entity = schema.find_entity_by_name(association_type)

      def association_type = super.singularize

      memoize def inverse_association = Associations::Association.build(
        type:,
        entity: inverse_entity,
        name: denied_name,
        options: { hidden: true }
      )

      def group_by
        :"#{options.group_by}_formatted" if options.group_by
      end

      def filter_by
        options.filter_by&.to_sym || :itself
      end

      def join_table = [entity, inverse_entity]
        .map(&:table_name)
        .map(&:pluralize)
        .sort
        .join('_')

      protected

      def prefixed? = false

      def association_to_str = <<~RUBY
        has_and_belongs_to_many :#{name},
                                class_name: '#{class_name}',
                                join_table: '#{join_table}',
                                foreign_key: '#{entity.table_name}_id',
                                association_foreign_key: '#{inverse_entity.table_name}_id'
      RUBY

      def denied_name = entity
        .name
        .pluralize
    end
  end
end
