# frozen_string_literal: true

class Emailing < Schematics::ApplicationRecord
  after_create_commit :deliver_emails

  private

  def deliver_emails
    recipients.each do |recipient|
      Schematics::ResourceMailer.forward(sender, recipient, record).deliver_later
    end
  end
end
