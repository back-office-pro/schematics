# frozen_string_literal: true

module Schematics
  class ApplicationRecord < ::Tenant.application_record_class
    primary_abstract_class

    self.implicit_order_column = 'created_at'
    self.inheritance_column = nil

    include Loadable
    include Duplicable
    include Serializable
    include Shortenable
    include Translatable
    include Mentionable
    include Previewable
    include Attachable

    loadable concerns: [Searchable, SoftDeletable, Trackable, Sluggable]
  end
end
