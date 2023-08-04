# frozen_string_literal: true

FriendlyId.defaults do |config|
  config.use :reserved, :finders, :history, :sequentially_slugged
  config.treat_reserved_as_conflict = true
  config.reserved_words = %i[new edit delete imports comments].flat_map do |word|
    I18n.available_locales.map { |locale| I18n.t(word, scope: :routes, locale:) }
  end
  config.use Module.new do
    def should_generate_new_friendly_id? = true
  end
end
