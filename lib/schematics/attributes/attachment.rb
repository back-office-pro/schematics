# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'action_dispatch/http/mime_type'
require 'active_support/core_ext/array/access'
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/numeric/bytes'

module Schematics
  module Attributes
    class Attachment < Attribute # rubocop:disable Metrics/ClassLength
      include Behaviours::Renderable
      include Behaviours::Searchable
      include Behaviours::Preloadable
      include Behaviours::Fillable

      delegate :default, :json_default, to: :dummy

      def available_options = super.push(
        Options::Size,
        Options::AspectRatio,
        Options::Width,
        Options::Height,
        Options::ContentType
      ).excluding(Options::Default)

      def open_api_body_type = 'file'

      def permitted_params = [
        super,
        { attributes_param_key => %i[id _destroy] }
      ]

      def permitted_json_params = [
        { permitted_params.first => %i[data filename content_type] },
        permitted_params.second
      ]

      def preload = [association_name => [blob: :variant_records]]

      def includes = { blob: :variant_records }

      def search_column = :"#{search_column_association}_filename"

      def search_column_association = "#{name}_blob"

      def to_sql = 'active_storage_blobs.filename'

      def to_str = <<~RUBY
        #{attached_method} :#{name}
        accepts_nested_attributes_for :#{association_name},
                                      update_only: true,
                                      allow_destroy: true,
                                      reject_if: :all_blank
      RUBY

      def extension
        ::Mime::Type.lookup(options.content_type.first).symbol if options.content_type
      end

      def validators = super
        .rename_keys(presence: :attached)
        .merge(
          antivirus: true,
          storage_quota: true,
          size: {
            less_than: options.size&.megabytes
          },
          aspect_ratio: options.aspect_ratio,
          dimension: {
            width: options.width,
            height: options.height
          },
          content_type: options.content_type && {
            with: options.content_type,
            spoofing_protection: true
          }
        )

      def format(value)
        value.attachment.to_s if value.attached?
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
          zip: :file_zipper,
          rar: :file_zipper,
          tar: :file_zipper,
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
          mp4: :file_video
        }[extension] || :file
      end

      def image?
        icon == :file_image
      end

      def attributes_param_key = :"#{association_name}_attributes"

      def association_name = [name, type]
        .join('_')
        .to_sym

      protected

      memoize def dummy = Specs::Dummy.new(extension)

      def attached_method = :has_one_base64_attached
    end
  end
end
