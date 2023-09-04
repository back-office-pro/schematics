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
      friendly_id entity.descriptor.slug_name

      scope :with_string_translations, -> { includes(:string_translations) }
      scope :with_slugs, -> { includes(:slugs) }

      def should_generate_new_friendly_id? = true

      def normalize_friendly_id(value)
        value.to_s.parameterize(preserve_case: true)
      end
    end
  end
end
