module Schematics
  module Attributes
    class Text < Attribute
      include Behaviours::Renderable
      include Behaviours::Searchable
      include Behaviours::Fillable
      include Behaviours::Editable

      def migration_options
        super + [:limit]
      end

      def api_param_type
        "string"
      end

      def search_data
        <<~RUBY
          #{name}&.searchize
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
