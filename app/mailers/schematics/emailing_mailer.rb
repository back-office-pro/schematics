# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class EmailingMailer < ApplicationMailer
    def dispatch(emailing_id, recipient_id)
      @emailing = ::Emailing.find(emailing_id)
      @recipient = ::User.find(recipient_id)
      @template = @emailing.email_template
      @resource = @emailing.record
      ::I18n.with_locale(@recipient.locale) do
        @emailing
          .serializers
          .each_with_object(@resource)
          .map(&:new)
          .select(&:content)
          .each { attachments[_1.filename] = _1.content }
      end
      mail_to(@recipient, @template.subject)
    end
  end
end
