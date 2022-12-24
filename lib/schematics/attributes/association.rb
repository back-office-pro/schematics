# frozen_string_literal: true

require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/string/inflections'

module Schematics
  module Attributes
    class Association < Attribute
      include Behaviours::Listable
      include Behaviours::Renderable
      include Behaviours::Searchable
      include Behaviours::Preloadable

      delegate :descriptor, :default, to: :inverse_entity
      delegate :polymorphic?, to: :options
      attr_accessor :inverse_entity

      validates :association_type,
                inclusion: { in: :allowed_association_types },
                unless: :polymorphic?

      def available_options = super.push(
        Options::Inverse,
        Options::Type,
        Options::Polymorphic
      )

      def open_api_type = { id!: ::String }

      def column_name = "#{super}_id"

      def weight = 2

      def migration_options = super.merge(
        index: { where: 'deleted_at IS NULL' },
        polymorphic: polymorphic?
      ).compact_blank

      def class_name = association_type.camelize

      def model_class = class_name.safe_constantize

      def inverse
        options.inverse || {}
      end

      def association_type
        options.type || name
      end

      def inverse_association_name
        inverse[:name] || entity.table_name
      end

      def preload
        return if association_type == entity.name # prevent self inclusion

        super
      end

      def search_column = :"#{name}_#{descriptor.name}"

      def to_sql = "#{inverse_entity.table_name.pluralize}.#{descriptor.name}"

      def to_str
        if polymorphic?
          <<~RUBY
            belongs_to :#{name},
                       -> { with_deleted },
                       foreign_key: '#{column_name}',
                       inverse_of: :#{inverse_association_name.pluralize},
                       optional: #{!required?},
                       polymorphic: true,
                       autosave: true,
                       counter_cache: :#{inverse_association_name.pluralize}_count
          RUBY
        else
          <<~RUBY
            belongs_to :#{name},
                       -> { with_deleted },
                       class_name: '#{class_name}',
                       foreign_key: '#{column_name}',
                       inverse_of: :#{inverse_association_name.pluralize},
                       optional: #{!required?},
                       autosave: true,
                       counter_cache: :#{inverse_association_name.pluralize}_count
          RUBY
        end
      end

      def inverse_association
        @inverse_association ||= Associations::Association.build(belongs_to: self, **inverse)
      end

      def icon
        inverse_entity&.icon || :link
      end

      def allowed_association_types = entity
        .schema
        .entities
        .map(&:name)
        .sort
    end
  end
end
