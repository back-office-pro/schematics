# frozen_string_literal: true

module Schematics
  class ApplicationMailer < ::ApplicationMailer
    self.deliver_later_queue_name = :mailers
    layout 'schematics/mailer'
    helper ApplicationHelper

    protected

    def mail_to(user)
      ::I18n.with_locale(user.locale) do
        bootstrap_mail to: email_address_with_name(user.email, user.full_name)
      end
    end
  end
end
