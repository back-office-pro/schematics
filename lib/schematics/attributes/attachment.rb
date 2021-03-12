require 'active_support/core_ext/module/delegation'
require 'schematics/attributes/attribute'
require 'schematics/behaviours/renderable'
require 'schematics/behaviours/searchable'
require 'schematics/behaviours/preloadable'
require 'schematics/behaviours/fillable'
require 'schematics/tests/dummy'

module Schematics
  module Attributes
    class Attachment < Attribute
      include Behaviours::Renderable
      include Behaviours::Searchable
      include Behaviours::Preloadable
      include Behaviours::Fillable
      delegate :default, :json_default, to: :dummy

      def permitted_params
        [
          super,
          { "#{association_name}_attributes": %i[id _destroy] },
        ]
      end

      def permitted_json_params
        [
          { permitted_params.first => %i[data filename content_type] },
          permitted_params.second,
        ]
      end

      def preload
        { association_name => [blob: :variant_records] }
      end

      def search_data
        <<~RUBY
          (#{name}.filename.to_s.searchize if #{name}.attached?)
        RUBY
      end

      def to_str
        <<~RUBY
          has_one_base64_attached :#{@name}
          accepts_nested_attributes_for :#{association_name},
                                        allow_destroy: true,
                                        reject_if: :all_blank
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
        case extension.to_sym
        when :doc, :docx                   then :file_word
        when :ppt, :pptx                   then :file_powerpoint
        when :pdf                          then :file_pdf
        when :png, :jpg, :jpeg, :gif, :bmp then :file_image
        when :xls, :xlsx                   then :file_excel
        when :zip, :rar, :tar              then :file_archive
        when :csv                          then :file_csv
        when :php, :rb, :py, :js, :java    then :file_code
        when :mp3, :aac, :ogg              then :file_audio
        when :webm, :mkv, :flv, :vob, :avi, :mov, :wmv, :mp4
          :file_video
        else
          :file
        end
      end

      def image?
        icon == :file_image
      end

      protected

      def association_name
        [name, type].join('_').to_sym
      end

      def dummy
        @dummy ||= Tests::Dummy.new(extension)
      end
    end
  end
end
