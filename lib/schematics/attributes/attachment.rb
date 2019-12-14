module Schematics
  module Attributes
    class Attachment < Attribute
      def api_param_type
        "file"
      end

      def scope
        super + %Q[filename { ActiveStorage::Attachment.joins(:blob).where(record_type: "#{@entity.type.camelize}").where("filename ILIKE ?", "%#\{filename}%") }]
      end

      def to_str
        %Q[has_one_attached :#{@name}]
      end

      def icon
        :paperclip
      end
    end
  end
end
