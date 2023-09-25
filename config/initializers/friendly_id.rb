# frozen_string_literal: true

FriendlyId.defaults do |config|
  config.use :reserved, :history, :mobility, :sequentially_slugged
  config.treat_reserved_as_conflict = true
  config.reserved_words = %i[new edit delete imports comments].flat_map do |word|
    I18n.available_locales.map { |locale| I18n.t(word, scope: :routes, locale:) }
  end
end

Rails.configuration.after_initialize do
  require 'friendly_id/mobility'
end
