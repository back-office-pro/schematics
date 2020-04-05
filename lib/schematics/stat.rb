module Schematics
  class Stat
    delegate :icon, to: :@entity

    def initialize(entity, agregate, field)
      @entity = entity
      @agregate = agregate
      @field = field
    end

    def title
      "#{@agregate} #{@field&.name} of #{@entity.type.pluralize}"
    end

    def field
      case @field
      when Virtuals::Virtual then @field.to_sql
      when nil then :all
      else
        @field.name.to_sym
      end
    end

    def to_s
      @entity.type.camelize.constantize.send(@agregate, field).to_s
    end

    def self.create(schema, entity:, agregate:, field: nil)
      entity = schema.find_entity_by_type(entity)
      field = entity.find_field_by_name(field) unless field.nil?
      new(entity, agregate.to_sym, field)
    end
  end
end
