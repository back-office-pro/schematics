module Schematics
  class Chart
    def initialize(entity, type, x_agregate, x_field, y_agregate, y_field)
      @entity     = entity
      @type       = type
      @x_agregate = x_agregate
      @x_field    = x_field
      @y_agregate = y_agregate
      @y_field    = y_field
    end

    def x_title
      "#{@x_agregate} #{@x_field.respond_to?(:name) ? @x_field.name : @x_field}"
    end

    def y_title
      "#{@y_agregate} #{@x_field.respond_to?(:name) ? @x_field.name : @x_field}"
    end

    def x_field
      field(@x_field)
    end

    def y_field
      field(@y_field)
    end

    def field(field)
      case field
      when Virtuals::Virtual then field.to_sql.to_json
      when String then ":#{field}"
      when nil then ":all"
      else
        ":#{field.name}"
      end
    end

    def title
      "#{x_title} by #{y_title}"
    end

    def to_str
      <<~RUBY
        #{@type}_chart(
          #{@entity.type.camelize}.#{@x_agregate}(#{x_field}).#{@y_agregate}(#{y_field}),
          xtitle: "#{x_title}",
          ytitle: "#{y_title}"
        )
      RUBY
    end

    def self.create(schema, entity:, type:, x:, y:)
      entity = schema.find_entity_by_type(entity)
      x_field = entity.find_field_by_name(x[:field]) || x[:field] unless x[:field].nil?
      y_field = entity.find_field_by_name(y[:field]) || y[:field] unless y[:field].nil?
      new(entity, type, x[:agregate], x_field, y[:agregate], y_field)
    end
  end
end
