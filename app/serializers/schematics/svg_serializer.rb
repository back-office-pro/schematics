# frozen_string_literal: true

module Schematics
  class SvgSerializer
    delegate :class, to: :@resource, prefix: :model, private: true
    delegate :human_name, to: :model_class, private: true

    def initialize(resource)
      @resource = resource
    end

    def content_type = ::Mime[extension].to_s

    def extension = :svg

    def content = qr_code.as_svg

    def filename = "#{human_name.dasherize}-#{@resource.slug}.#{extension}"

    private

    def serialized_json
      @serialized_json ||= ActiveSupport::JSON.encode(@resource.serialized_json)
    end

    def qr_code
      @qr_code ||= RQRCode::QRCode.new(serialized_json)
    end
  end
end
