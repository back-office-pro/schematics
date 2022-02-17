# frozen_string_literal: true

module Schematics
  module Sluggable
    extend ActiveSupport::Concern

    included do
      extend FriendlyId
      friendly_id entity.descriptor.name.to_sym
      validates :slug, uniqueness: true, allow_blank: true
    end
  end
end
