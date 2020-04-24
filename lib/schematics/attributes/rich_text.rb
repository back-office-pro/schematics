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

      def joins
        [type, name].join("_").to_sym
      end

      def filter_scope
        super.extends <<~RUBY
          body do
            joins(:#{joins}).
            where("action_text_rich_texts.body ILIKE ?", "%#\{body}%")
          end
        RUBY
      end

      def sort_scope
        super.extends <<~RUBY
          sort_direction do
            left_joins(:#{joins}).
            order("action_text_rich_texts.body": sort_direction)
          end
        RUBY
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
