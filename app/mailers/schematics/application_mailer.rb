# frozen_string_literal: true

module Schematics
  class ApplicationMailer < ::ActionMailer::Base
    self.deliver_later_queue_name = :default

    layout 'schematics/mailer'
    helper ApplicationHelper

    protected

    def mail_to(user, subject = nil)
      ::I18n.with_locale(user.locale) do
        to = email_address_with_name(user.email, user.full_name)
        from = "no-reply@#{::Configuration.host}"
        bootstrap_mail(**{ to:, from:, subject: }.compact)
      end
    end
  end
end
