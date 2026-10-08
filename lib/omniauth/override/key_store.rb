# frozen_string_literal: true

module OmniAuth
  module Override
    module KeyStore
      def client_id
        super.try(:call) || super
      end

      def client_secret
        super.try(:call) || super
      end
    end
  end
end
