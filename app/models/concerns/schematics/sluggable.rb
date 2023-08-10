# frozen_string_literal: true

module Schematics
  module Sluggable
    extend ActiveSupport::Concern

    included do
      extend Mobility
      translates :slug, type: :string

      extend FriendlyId
      friendly_id entity.descriptor.name.to_sym

      scope :with_string_translations, -> { preload(:string_translations) }
      scope :with_slugs, -> { preload(:slugs) }
    end
  end
end
