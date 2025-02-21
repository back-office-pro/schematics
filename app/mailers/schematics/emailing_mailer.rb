# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class EmailingMailer < ApplicationMailer
    def dispatch(emailing, recipient)
      @template = emailing.email_template
      @resource = emailing.record
      ::I18n.with_locale(recipient.locale) do
        emailing
          .serializers
          .select(&:content)
          .each { attachments[it.filename] = it.content }
      end
      mail_to(recipient, @template.subject)
    end
  end
end
