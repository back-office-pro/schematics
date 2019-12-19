module Schematics
  module Attributes
    class RichText < Attribute
      def api_param_type
        "string"
      end

      def filter_scope
        super + %Q[body { joins(:action_text_rich_text).where("action_text_rich_texts.record_id = ? AND action_text_rich_texts.body ILIKE ?", self.id, "%#\{body}%") }]
      end

      def sort_scope
        super + %Q[sort_direction { joins(:action_text_rich_text).where(record_id: self.id).order(body: sort_direction) }]
      end

      def to_str
        %Q[has_rich_text :#{@name}]
      end
    end
  end
end
