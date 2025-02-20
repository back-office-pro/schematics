# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class ApplicationRecord < ::Server.application_record_class
    primary_abstract_class

    self.implicit_order_column = 'created_at'
    self.inheritance_column = nil

    include Loadable
    include Duplicable
    include Serializable
    include Identifiable
    include Translatable
    include Mentionable
    include Previewable
    include Attachable
    include Routable

    loadable concerns: [
      SoftDeletable,
      Multisearchable,
      Searchable,
      Trackable,
      Sluggable
    ]
  end
end
