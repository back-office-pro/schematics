module Schematics
  module MessageModal
    class Component < ::ViewComponent::Base
      delegate :fa_icon, to: :helpers
      delegate :id, :subject, :content, to: :@message

      def initialize(message:)
        @message = message
      end
    end
  end
end
