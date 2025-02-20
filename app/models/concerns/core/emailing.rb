# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Core
  module Emailing
    extend ActiveSupport::Concern

    prepended do
      after_create_commit :deliver_emails
    end

    def serializers = [
      (Schematics::PDFSerializer if pdf_attachment?),
      (Schematics::ICSSerializer if ics_attachment?),
      (Schematics::SVGSerializer if svg_attachment?)
    ].compact

    private

    def deliver_emails
      recipients.each do |recipient|
        Schematics::EmailingMailer.dispatch(self, recipient).deliver_later
      end
    end
  end
end
