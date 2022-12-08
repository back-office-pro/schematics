# frozen_string_literal: true

module Schematics
  module ApplicationRecord
    extend ActiveSupport::Concern

    included do
      include Loadable
      include Translatable
      include Attachable
      loadable concerns: [
        Elasticsearchable,
        SoftDeletable,
        Versionable,
        Sluggable
      ]
    end
  end
end
