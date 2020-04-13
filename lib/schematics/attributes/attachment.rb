module Schematics
  module Attributes
    class Attachment < Attribute
      include Behaviours::Renderable
      include Behaviours::Filterable
      include Behaviours::Sortable
      include Behaviours::Preloadable

      delegate :default, :json_default, to: :dummy

      def api_param_type
        "file"
      end

      def permitted_json_param
        { super => [:data, :filename, :content_type] }
      end

      def joins
        { [name, type].join("_").to_sym => :blob }
      end

      def filter_scope
        super.extends <<~RUBY
          filename do
            joins(:#{joins.keys.first}, :#{@name}_blob).
            where("active_storage_blobs.filename ILIKE ?", "%#\{filename}%")
          end
        RUBY
      end

      def sort_scope
        super.extends <<~RUBY
          sort_direction do
            left_joins(:#{joins.keys.first}, :#{@name}_blob).
            order("active_storage_blobs.filename": sort_direction)
          end
        RUBY
      end

      def to_str
        <<~RUBY
          has_one_attached :#{@name}
          has_one_base64_attached :#{@name}
        RUBY
      end

      def extension
        @options[:content_type]&.first || 'png'
      end

      def validators
        validators = super
        validators[:attached] = true if required?
        validators[:size] = { less_than: @options[:size].megabytes } if @options.key?(:size)
        validators[:aspect_ratio] = @options[:aspect_ratio] if @options.key?(:aspect_ratio)
        validators[:limit] = { min: @options[:min] } if @options.key?(:min)
        validators[:limit] = { max: @options[:max] } if @options.key?(:max)
        validators[:dimension] = { width: @options[:width] } if @options.key?(:width)
        validators[:dimension] = { height: @options[:height] } if @options.key?(:height)
        if @options.key?(:min) && @options.key?(:max)
          validators[:limit] = { min: @options[:min], max: @options[:max] }
        end
        if @options.key?(:width) && @options.key?(:height)
          validators[:dimension] = { width: @options[:width], height: @options[:height] }
        end
        if @options.key?(:content_type)
          validators[:content_type] = @options[:content_type].map(&:to_sym)
        end
        validators
      end

      def format(value)
        Rails.application.routes.url_helpers.url_for(value) if value.attached?
      end

      def icon
        :paperclip
      end

      protected

      def dummy
        @dummy ||= Tests::Dummy.new(extension)
      end
    end
  end
end
