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

      delegate :icon, to: :entity
      attr_accessor :inverse_descriptor

      def migration_options
        super + %i[polymorphic type]
      end

      def column_name
        "#{super}_id"
      end

      def class_name
        association_type.camelize
      end

      def association_type
        @options[:type] || @name
      end

      def inverse_association_name
        @options.dig(:inverse, :name) || @entity.name
      end

      def preload
        return if association_type == @entity.name # prevent self inclusion
        super
      end

      def search_data
        <<~RUBY
          #{name}&.#{inverse_descriptor.name}&.searchize
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

      def inverse_of_has_one?
        @options.dig(:inverse, :type) == 'has_one'
      end

      def inverse_of_has_many?
        @options.dig(:inverse, :type) == 'has_many'
      end

      def inverse_association
        @inverse_association ||= Associations::Association.create(self, **@options[:inverse])
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
    end
  end
end
