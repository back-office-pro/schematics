module Schematics
  module Attributes
    class RichText < Attribute
      def api_param_type
        "string"
      end

      def filter_scope
        super + %Q[body { ActionText::where(record: self).where("body ILIKE ?", "%#\{body}%") }]
      end

      def to_str
        %Q[has_rich_text :#{@name}]
      end
    end
  end
end
