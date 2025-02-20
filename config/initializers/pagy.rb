# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'pagy/extras/bootstrap'
require 'pagy/extras/calendar'
require 'pagy/extras/headers'
require 'pagy/extras/i18n'
require 'pagy/extras/limit'
require 'pagy/extras/overflow'

module LocalizePagyCalendar
  def localize(time, opts)
    ::I18n.l(time, **opts)
  end
end

Pagy::Calendar.prepend(LocalizePagyCalendar)
