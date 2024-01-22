# frozen_string_literal: true

module Schematics
  module Forwardings
    class Create
      include Interactable
      delegate :sender, :record, :recipients, to: :context, private: true

      def call
        recipients.each do |recipient|
          ResourceMailer.forward(sender, recipient, record).deliver_later
        end
      end
    end
  end
end
