# frozen_string_literal: true

module Schematics
  class ResourceMailer < ApplicationMailer
    def forward(sender, recipient, resources)
      case resources
      when Enumerable
        serializer = CsvSerializer.new(resources, sender.preferences)
        attachments[serializer.filename] = serializer.content
      else
        [PdfSerializer, SvgSerializer, IcsSerializer]
          .each_with_object(resources)
          .map(&:new)
          .select(&:content)
          .each { attachments[_1.filename] = _1.content }
      end
      @sender = sender
      @recipient = recipient
      mail_to(recipient)
    end
  end
end
