# frozen_string_literal: true

require 'pagy/extras/bootstrap'
require 'pagy/extras/calendar'
require 'pagy/extras/headers'
require 'pagy/extras/i18n'
require 'pagy/extras/items'
require 'pagy/extras/overflow'
require 'pagy/extras/searchkick'

module LocalizePagyCalendar
  def localize(time, opts)
    ::I18n.l(time, **opts)
  end
end

Pagy::Calendar.prepend(LocalizePagyCalendar)
