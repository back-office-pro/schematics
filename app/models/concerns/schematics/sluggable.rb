# frozen_string_literal: true

module Schematics
  module Sluggable
    extend ActiveSupport::Concern

    included do
      extend FriendlyId
      friendly_id entity.descriptor.name.to_sym
      scope :with_slugs, -> { preload(:slugs) }
    end
  end
end
