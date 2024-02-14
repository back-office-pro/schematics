# frozen_string_literal: true

require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/string/inflections'

module Schematics
  module Attributes
    class Association < Attribute # rubocop:disable Metrics/ClassLength
      include Behaviours::Migratable
      include Behaviours::Listable
      include Behaviours::Renderable
      include Behaviours::Searchable
      include Behaviours::Preloadable
      include Behaviours::Fillable

      delegate :descriptor, to: :inverse_entity
      delegate :to_sql, to: :descriptor
      delegate :polymorphic?, to: :options

      validates :association_type,
                inclusion: { in: :allowed_association_types },
                unless: :polymorphic?

      def available_options = super
        .excluding(Options::Default)
        .push(
          Options::InverseAssociationName,
          Options::InverseAssociationType,
          Options::Type,
          Options::Polymorphic
        )

      def database_type = 'belongs_to'

      def default
        return if association_type == entity.name # prevent infinite loop

        inverse_entity.default
      end

      def open_api_type = { id!: ::String }

      def column_name = "#{super}_id"

      def weight = 2

      def migration_options = super.merge(
        index: { where: 'deleted_at IS NULL' },
        polymorphic: polymorphic?
      ).compact_blank

      def class_name = association_type.camelize

      def model_class = class_name.safe_constantize

      def association_type
        options.type || name
      end

      def inverse_association_name
        options.inverse_association_name || entity.table_name
      end

      def inverse_association_type
        options.inverse_association_type || 'has_many'
      end

      def preload = [name.to_sym => :string_translations]

      def search_data = super
        .concat(' ')
        .concat <<~RUBY
          #{name}&.to_s
        RUBY

      def search_column = :"#{name}_#{descriptor.name}"

      def to_str = [scope_to_str, second_level_scopes_to_str, association_to_str]
        .compact
        .join

      def inverse_entity
        return entity.schema.find_entity_by_name(association_type) unless polymorphic?

        entity
          .schema
          .entities
          .excluding(entity)
          .first
      end

      memoize def inverse_association = Associations::Association.build(
        type: inverse_association_type,
        name: inverse_association_name,
        belongs_to: self
      )

      def icon
        return :link unless inverse_entity
        return :link if polymorphic?

        inverse_entity.icon
      end

      def allowed_association_types = entity
        .schema
        .entities
        .reject(&:hidden?)
        .reject(&:existing?)
        .map(&:name)
        .sort

      protected

      def association_to_str
        if polymorphic?
          <<~RUBY
            belongs_to :#{name},
                       -> { with_deleted },
                       foreign_key: '#{column_name}',
                       inverse_of: :#{inverse_association.name},
                       optional: #{!required?},
                       polymorphic: true,
                       autosave: true
          RUBY
        else
          <<~RUBY
            belongs_to :#{name},
                       -> { with_deleted },
                       class_name: '#{class_name}',
                       foreign_key: '#{column_name}',
                       inverse_of: :#{inverse_association.name},
                       optional: #{!required?},
                       autosave: true
          RUBY
        end
      end

      def scope_to_str
        if polymorphic?
          <<~RUBY
            scope :with_#{name}, -> { preload(#{preload}) }
          RUBY
        else
          <<~RUBY
            scope :with_#{name}, -> { includes(#{preload}) }
          RUBY
        end
      end

      def second_level_scopes_to_str
        return if polymorphic?

        inverse_entity
          .preloadable_elements
          .select { _1.preload.any? }
          .map do |element|
            <<~RUBY
              scope :with_#{name}_#{element.name}, -> { includes(#{{ name.to_sym => element.preload }}) }
            RUBY
          end.join
      end
    end
  end
end
