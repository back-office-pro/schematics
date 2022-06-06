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

      def available_options = super.push(
        :inverse,
        :type,
        :polymorphic
      )

      def open_api_type = { id!: ::String }

      def column_name = "#{super}_id"

      def weight = 2

      def migration_options = super.merge(
        foreign_key: { to_table: association_type.pluralize.to_sym },
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

      def search_data = super
        .concat(' ')
        .concat <<~RUBY
          #{name}&.to_s
        RUBY

      def to_str = <<~RUBY
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

      def inverse_association
        @inverse_association ||= Associations::Association.build(belongs_to: self, **inverse)
      end

      def icon
        inverse_entity&.icon || :link
      end
    end
  end
end
