module Schematics
  module Attributes
    class RichText < Attribute
      include Behaviours::Renderable
      include Behaviours::Filterable
      include Behaviours::Sortable
      include Behaviours::Searchable
      include Behaviours::Preloadable
      include Behaviours::Fillable

      def api_param_type
        "string"
      end

      def includes
        [[type, name].join("_").to_sym]
      end

      def search_field
        :"rich_text_#{name}_body_cont"
      end

      def sort_field
        :"rich_text_#{name}_body"
      end

      def format(value)
        value&.to_plain_text
      end

      def default
        SecureRandom.base58
      end

      def icon
        :align_justify
      end

      def to_str
        <<~RUBY
          has_rich_text :#{@name}
        RUBY
      end
    end
  end
end
