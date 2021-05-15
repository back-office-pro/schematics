require 'schematics/attributes/attribute'
require 'schematics/behaviours/listable'
require 'schematics/behaviours/renderable'
require 'schematics/behaviours/searchable'
require 'schematics/behaviours/preloadable'
require 'schematics/behaviours/editable'
require 'active_support/core_ext/module/delegation'

module Schematics
  module Attributes
    class Association < Attribute
      include Behaviours::Listable
      include Behaviours::Renderable
      include Behaviours::Searchable
      include Behaviours::Preloadable
      include Behaviours::Editable

      delegate :icon, :descriptor, to: :inverse_entity
      attr_accessor :inverse_entity

      def options_for_migration
        super.merge(foreign_key: { to_table: association_type.pluralize.to_sym })
      end

      def column_name
        "#{super}_id"
      end

      def class_name
        association_type.camelize
      end

      def inverse
        @options[:inverse] || {}
      end

      def association_type
        @options[:type] || @name
      end

      def inverse_association_name
        inverse[:name] || @entity.name
      end

      def preload
        return if association_type == @entity.name # prevent self inclusion
        super
      end

      def search_data
        <<~RUBY
          #{name}&.#{descriptor.name}&.parameterize(separator: ' ')
        RUBY
      end

      def to_str
        <<~RUBY
          belongs_to :#{@name},
                     class_name: '#{class_name}',
                     foreign_key: '#{column_name}',
                     inverse_of: :#{inverse_association.name},
                     optional: #{!required?}
        RUBY
      end

      def inverse_association
        @inverse_association ||= Associations::Association.create(self, **inverse)
      end

      def input_type
        :select
      end

      def input_collection
        class_name.constantize.all.collect do |association|
          [association.id, association.to_s]
        end
      end

      def weight
        2
      end

      protected

      def migration_options
        super.concat %i[polymorphic]
      end
    end
  end
end
