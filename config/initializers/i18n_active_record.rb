# frozen_string_literal: false

require 'i18n/backend/active_record'

::I18n.backend = ::I18n::Backend::Chain.new(
  ::I18n::Backend::Simple.new,
  ::I18n::Backend::ActiveRecord.new
)
