module Schematics
  module Attributes
    class Text < Attribute
      include Behaviours::Renderable
      include Behaviours::Filterable
      include Behaviours::Sortable
      include Behaviours::Searchable
      include Behaviours::Fillable
      include Behaviours::Editable
      include Behaviours::Default::Sortable

      def migration_options
        super + [:limit]
      end

      def api_param_type
        "string"
      end

      def filter_scope
        super.extends <<~RUBY
          #{@name} do
            where("#{@entity.type.pluralize}.#{@name} ILIKE ?", "%#\{#{@name}}%")
          end
        RUBY
      end

      def icon
        :align_justify
      end

      def input_type
        :textarea
      end
    end
  end
end
