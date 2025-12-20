# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class ApplicationMailer < ::ActionMailer::Base
    self.deliver_later_queue_name = :default

    layout 'schematics/mailer'
    helper ApplicationHelper

    around_action do |_mailer, block|
      ActiveRecord::Base.connected_to(shard: params[:shard]) { block.call }
    end

    protected

    def mail_to(user, subject = nil)
      ::I18n.with_locale(user.locale) do
        to = email_address_with_name(user.email, user.full_name)
        bootstrap_mail(**{ to:, subject: }.compact)
      end
    end
  end
end
