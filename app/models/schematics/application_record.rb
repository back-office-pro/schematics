# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class ApplicationRecord < ::ActiveRecord::Base
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

    delegate :name, to: :class, prefix: true, private: true
    delegate :current_shard, to: :class

    loadable concerns: [
      SoftDeletable,
      Multisearchable,
      Searchable,
      Trackable,
      Sluggable
    ]
  end
end
