# frozen_string_literal: true

class Emailing < Schematics::ApplicationRecord
  after_create_commit :deliver_emails

  def serializers = %i[pdf svg ics]
    .select { public_send(:"#{_1}_attachment?") }
    .map(&:upcase)
    .map { "#{_1}Serializer" }
    .map(&Schematics.method(:const_get))

  private

  def deliver_emails
    recipients.each do |recipient|
      Schematics::EmailingMailer.dispatch(self, recipient).deliver_later
    end
  end
end
