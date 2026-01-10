# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

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
