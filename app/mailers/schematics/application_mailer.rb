# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class ApplicationMailer < ::Server.application_mailer_class
    self.deliver_later_queue_name = :default
    default from: ::Server.no_reply_email
    layout 'schematics/mailer'
    helper ApplicationHelper

    protected

    def mail_to(user, subject = nil)
      ::I18n.with_locale(user.locale) do
        to = email_address_with_name(user.email, user.full_name)
        bootstrap_mail(**{ to:, subject: }.compact)
      end
    end
  end
end
