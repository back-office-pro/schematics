# frozen_string_literal: true

module Schematics
  module Button
    module PasswordLost
      class Component < ApplicationComponent
        delegate :sendmail_settings, to: '::ActionMailer::Base', private: true
        delegate :mailer_configured?, to: '::Configuration', private: true

        def title
          t('.missing_mailer_configuration') if disabled?
        end

        def css_classes = class_names(
          'btn',
          'btn-link',
          'btn-sm',
          'text-decoration-none',
          disabled: disabled?
        )

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
