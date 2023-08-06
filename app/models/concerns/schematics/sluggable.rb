# frozen_string_literal: true

module Schematics
  module Sluggable
    extend ActiveSupport::Concern

    included do
      extend FriendlyId
      friendly_id entity.descriptor.name.to_sym
    end
  end
end
