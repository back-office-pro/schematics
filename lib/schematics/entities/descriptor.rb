module Schematics
  module Entities
    class Descriptor
      delegate :name, :entity, to: :@field

      class << self
        def create(entity, descriptor)
          field = entity.find_field_by_name(descriptor)
          new(field)
        end
      end

      def initialize(field)
        @field = field
      end

      def to_sql
        case @field
        when Virtuals::Virtual
          @field.to_sql
        else
          name
        end
      end

      def to_s
        @name
      end

      def to_str
        <<~RUBY
          extend FriendlyId
          friendly_id :#{name}
          alias_attribute :to_s, :#{name}
        RUBY
      end

      def serializer_class
        descriptor = name
        case entity
        when Singleton
          Class.new ActiveModel::Serializer do
            attribute descriptor
          end
        when Entity
          Class.new ActiveModel::Serializer do
            attribute :id
            attribute descriptor if descriptor != 'id'
          end
        end
      end
    end
  end
end
