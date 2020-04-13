module Schematics
  module Attributes
    class Text < Attribute
      include Behaviours::Renderable
      include Behaviours::Filterable
      include Behaviours::Sortable
      include Behaviours::Default::Sortable
      include Behaviours::Searchable

      def migration_options
        super + [:limit]
      end

      def api_param_type
        "string"
      end

      def filter_scope
        super.extends <<~RUBY
          #{@name} { where("#{@entity.type.pluralize}.#{@name} ILIKE ?", "%#\{#{@name}}%") }
        RUBY
      end
    end
  end
end
