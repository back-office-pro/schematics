# frozen_string_literal: true

module Schematics
  module Sluggable
    extend ActiveSupport::Concern

    included do
      extend Mobility
      translates :slug,
                 type: :string,
                 column_fallback: false,
                 fallbacks: false

      extend FriendlyId
      friendly_id entity.descriptor.name.to_sym

      scope :with_string_translations, -> { includes(:string_translations) }
      scope :with_slugs, -> { includes(:slugs) }
    end
  end
end
