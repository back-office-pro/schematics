# frozen_string_literal: true

module Schematics
  module LicenseComparisonModal
    module Button
      module Checkout
        class Component < ApplicationComponent
          delegate :secret_key_base, to: '::Rails.configuration', private: true

          def title = t('.title')

          def icon = :cart_shopping

          def path = "/buy/#{token}"

          def target = '_blank'

          def rel = 'noreferrer'

          def wrapper_css_classes = %w[btn btn-primary btn-sm btn-icon-split]

          private

          def token
            Base64.strict_encode64(secret_key_base)
          end
        end
      end
    end
  end
end
