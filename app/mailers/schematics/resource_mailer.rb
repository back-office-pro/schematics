# frozen_string_literal: true

module Schematics
  class ResourceMailer < ApplicationMailer
    SERIALIZERS = [PdfSerializer, SvgSerializer, IcsSerializer].freeze

    def forward(sender, recipient, resource)
      @sender = sender
      @recipient = recipient
      ::I18n.with_locale(recipient.locale) do
        SERIALIZERS
          .each_with_object(resource)
          .map(&:new)
          .select(&:content)
          .each { attachments[_1.filename] = _1.content }
      end
      mail_to(recipient)
    end
  end
end
