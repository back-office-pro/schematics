# frozen_string_literal: true

module Schematics
  class SvgSerializer
    delegate :class, to: :@resource, prefix: :model, private: true
    delegate :human_name, to: :model_class, private: true
    delegate :to_json, to: :json_serializer, private: true

    def initialize(resource)
      @resource = resource
    end

    def content_type = ::Mime[extension].to_s

    def extension = :svg

    def file = qr_code.as_svg

    def filename = "#{human_name.dasherize}-#{@resource.slug}.#{extension}"

    private

    def json_serializer
      @json_serializer ||= ::ActiveModelSerializers::SerializableResource.new(@resource)
    end

    def qr_code
      @qr_code ||= RQRCode::QRCode.new(to_json)
    end
  end
end
