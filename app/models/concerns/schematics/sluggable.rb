# frozen_string_literal: true

module Schematics
  module Sluggable
    extend ActiveSupport::Concern

    included do
      extend FriendlyId
      friendly_id entity.descriptor.name.to_sym
      has_many :slugs,
               -> { order(created_at: :desc) },
               as: :sluggable,
               dependent: :destroy,
               class_name: 'FriendlyId::Slug',
               strict_loading: false,
               inverse_of: false
    end
  end
end
