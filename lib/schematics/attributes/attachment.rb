module Schematics
  module Attributes
    class Attachment < Attribute
      def api_param_type
        "file"
      end

      def filter_scope
        super + %Q[filename { ActiveStorage::Attachment.joins(:blob).where(record_type: "#{@entity.type.camelize}").where("filename ILIKE ?", "%#\{filename}%") }]
      end

      def sort_scope
        nil
      end

      def to_str
        %Q[has_one_attached :#{@name}]
      end

      def validators
        validators = super
        validators[:attached] = true if required?
        validators[:content_type] = @options[:content_type].map(&:to_sym) if @options.key?(:content_type)
        validators[:size] = { less_than: @options[:size].megabytes } if @options.key?(:size)
        validators
      end

      def icon
        :paperclip
      end
    end
  end
end
