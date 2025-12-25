# Copyright © 2025 Dev & Software. All rights reserved.
#
# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

module Schematics
  class ImportJob < ApplicationJob
    include Quietable

    queue_as :default

    discard_on ActiveStorage::FileNotFoundError

    after_discard do |job|
      PaperTrail.request(enabled: false) do
        suppress(ActiveRecord::RecordNotFound) do
          job.arguments.first.reload.state_error!
        end
      end
    end

    def perform(import)
      return unless import.state_pending?

      I18n.with_locale(import.locale) do
        import.state_in_progress!
        import.finalize!(Core::Imports::ImportData.call(import:).errors)
      end
    end
  end
end
