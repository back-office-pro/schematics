require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/array/access'
require 'active_support/core_ext/numeric/bytes'
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
          (#{name}.filename.to_s.parameterize(separator: ' ') if #{name}.attached?)
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
        super.merge(
          {
            attached: required?,
            size: {
              less_than: @options[:size]&.megabytes,
            }.compact,
            aspect_ratio: @options[:aspect_ratio],
            limit: {
              min: @options[:min],
              max: @options[:max],
            }.compact,
            dimension: {
              width: @options[:width],
              height: @options[:height],
            }.compact,
            content_type: @options[:content_type]&.map(&:to_sym),
          }.compact_blank
        )
      end

      def format(value)
        Rails.application.routes.url_helpers.url_for(value) if value.attached?
      end

      def icon
        {
          doc: :file_word,
          docx: :file_word,
          ppt: :file_powerpoint,
          pptx: :file_powerpoint,
          pdf: :file_pdf,
          png: :file_image,
          jpg: :file_image,
          jpeg: :file_image,
          gif: :file_image,
          bmp: :file_image,
          xls: :file_excel,
          xlsx: :file_excel,
          zip: :file_archive,
          rar: :file_archive,
          tar: :file_archive,
          csv: :file_csv,
          php: :file_code,
          rb: :file_code,
          py: :file_code,
          js: :file_code,
          java: :file_code,
          mp3: :file_audio,
          aac: :file_audio,
          ogg: :file_audio,
          webm: :file_video,
          mkv: :file_video,
          flv: :file_video,
          vob: :file_video,
          avi: :file_video,
          mov: :file_video,
          wmv: :file_video,
          mp4: :file_video,
        }[extension.to_sym] || :file
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
