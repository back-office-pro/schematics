# frozen_string_literal: true

module Schematics
  module Footer
    module HelpCenter
      module PrivacyPolicy
        class Component < ApplicationComponent
          delegate :url, to: ::Tenant

          def title = t('.text')

          def icon = :user_secret

          def path = '/privacy-policy'

          def target = '_blank'

          def icon_css_classes = %w[fa-fw me-3]

          def wrapper_css_classes = %w[dropdown-item]
        end
      end
    end
  end
end
