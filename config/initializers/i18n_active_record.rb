# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: false

require 'i18n/backend/active_record'
require 'i18n/backend/route_translator'

I18n.backend = I18n::Backend::Chain.new(
  I18n::Backend::Simple.new,
  I18n::Backend::RouteTranslator.new,
  I18n::Backend::ActiveRecord.new
)
