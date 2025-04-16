# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

class ::Emailing < Schematics::ApplicationRecord
  after_create_commit :deliver_emails

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
