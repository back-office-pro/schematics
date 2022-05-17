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

      delegate :descriptor, to: :inverse_entity
      delegate :polymorphic?, to: :options
      attr_accessor :inverse_entity

      def open_api_type = { id!: ::String }

      def column_name = "#{super}_id"

      def weight = 2

      def options_for_migration
        super.merge(foreign_key: { to_table: association_type.pluralize.to_sym })
      end

      def class_name
        association_type.camelize
      end

      def model_class
        class_name.safe_constantize
      end

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

      def search_data
        super
          .concat(' ')
          .concat <<~RUBY
            #{name}&.to_s
          RUBY
      end

      def to_str
        <<~RUBY
          belongs_to :#{name},
                     -> { with_deleted },
                     class_name: '#{class_name}',
                     foreign_key: '#{column_name}',
                     inverse_of: :#{inverse_association_name.pluralize},
                     optional: #{!required?},
                     polymorphic: #{polymorphic?},
                     autosave: true,
                     counter_cache: :#{inverse_association_name.pluralize}_count
        RUBY
      end

      def inverse_association
        @inverse_association ||= Associations::Association.build(belongs_to: self, **inverse)
      end

      def icon
        inverse_entity&.icon || :link
      end

      # :reek:FeatureEnvy
      def collection
        model_class
          .all
          .map { [_1.to_s, _1.id] }
          .sort
      end

      protected

      def migration_options
        super.concat %i[polymorphic]
      end
    end
  end
end
