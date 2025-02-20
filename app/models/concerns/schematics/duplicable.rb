# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Duplicable
    extend ActiveSupport::Concern

    def dup = super.tap do |new_record|
      self
        .class
        .entity
        .has_and_belongs_to_many_associations
        .map(&:name)
        .each { new_record.public_send(:"#{it}=", public_send(it)) }
    end
  end
end
