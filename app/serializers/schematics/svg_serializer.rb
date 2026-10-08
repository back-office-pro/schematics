# frozen_string_literal: true

module Schematics
  class SVGSerializer
    delegate :class, to: :@resource, prefix: :model, private: true
    delegate :human_name, to: :model_class, private: true

    def initialize(resource)
      @resource = resource
    end

    def content_type = ::Mime[extension].to_s

    def extension = :svg

    memoize def content = qr_code.as_svg

    def filename = "#{human_name.parameterize}-#{@resource.to_param}.#{extension}"

    private

    memoize def qr_code = RQRCode::QRCode.new(@resource.to_json(root: false))
  end
end
