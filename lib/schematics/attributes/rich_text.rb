module Schematics
  module Attributes
    class RichText < Attribute
      def api_param_type
        "string"
      end

      def filter_scope
        super.extends <<~RUBY
          body do
            joins(:action_text_rich_text).
            where("action_text_rich_texts.record_id = ? AND action_text_rich_texts.body ILIKE ?", self.id, "%#\{body}%")
          end
        RUBY
      end

      def sort_scope
        super.extends <<~RUBY
          sort_direction do
            joins(:action_text_rich_text).
            where(record_id: self.id).order(body: sort_direction)
          end
        RUBY
      end

      def to_str
        <<~RUBY
          has_rich_text :#{@name}
        RUBY
      end
    end
  end
end
