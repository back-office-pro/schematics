# frozen_string_literal: true

module Schematics
  module Button
    module Emailing
      class Component < ApplicationComponent
        delegate :sendmail_settings, to: '::ActionMailer::Base', private: true
        delegate :mailer_configured?, to: '::Configuration', private: true
        delegate :icon, to: '::Emailing.entity'

        option :resource

        def data = {
          turbo_frame: '_top',
          controller: 'tooltip',
          'bs-custom-class': 'responsive-button-tooltip-xxl'
        }

        def title
          t('.missing_mailer_configuration') if disabled?
        end

        def css_classes = class_names(
          'btn',
          'btn-sm',
          'btn-icon-split',
          'bg-body-tertiary',
          'ms-1',
          disabled: disabled?
        )

        def path = new_emailing_resource_path(resource)

        def render?
          can?(:email, resource)
        end

        private

        def disabled?
          !(sendmail_configured? || mailer_configured?)
        end

        def sendmail_configured?
          File.executable?(sendmail_settings[:location])
        end
      end
    end
  end
end
