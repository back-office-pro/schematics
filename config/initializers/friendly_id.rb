# frozen_string_literal: true

FriendlyId.defaults do |config|
  config.use :reserved, :history, :mobility, :sequentially_slugged
  config.treat_reserved_as_conflict = true
  config.reserved_words = Schematics::Sluggable::RESERVED_WORDS.flat_map do |word|
    I18n.available_locales.map { |locale| I18n.t(word, scope: :routes, locale:) }
  end
end

Rails.configuration.to_prepare do
  require 'friendly_id/mobility'

  FriendlyId::Mobility::FinderMethods.class_eval do
    def exists_by_friendly_id?(id)
      exists?("#{name.underscore.pluralize}.#{friendly_id_config.query_field} = ?", id) ||
        joins(:slugs).where(slug_history_clause(id)).exists?
    end
  end
end
