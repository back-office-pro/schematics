# frozen_string_literal: true

FriendlyId.defaults do |config|
  config.use :reserved, :history, :mobility, :sequentially_slugged
  config.slug_limit = 255
  config.treat_reserved_as_conflict = true
  config.reserved_words = Schematics::Sluggable::RESERVED_WORDS.flat_map do |word|
    I18n.available_locales.map { |locale| I18n.t(word, scope: :routes, locale:) }
  end
end
