# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

require 'active_model'

module Schematics
  module Commands
    # :reek:Attribute
    class Command
      include Behaviours::Specifiable
      include ::ActiveModel::API

      delegate :human, to: :model_name, private: true
      delegate :table_name, to: :source_entity, private: true
      delegate :name,
               :class_name,
               :association_attributes,
               :actions_with_events,
               :core?,
               :existing?,
               :source_entity,
               :children,
               :abstract?,
               :child?,
               :schema,
               to: :entity,
               private: true
      attr_accessor :entity, :attribute, :target

      def generators = []

      def weight = 1

      protected

      def translatable_elements = entity
        .fields
        .concat(has_and_belongs_to_many_associations)
        .concat(entity.enum_attributes.flat_map(&:enum_values))
        .concat(entity.state_machine_attributes.flat_map(&:events))

      def has_and_belongs_to_many_associations = entity # rubocop:disable Naming/PredicatePrefix
        .has_and_belongs_to_many_associations
        .reject(&:hidden?)

      def migratable_attributes = entity
        .migratable_attributes
        .concat(children.flat_map(&:migratable_attributes))
        .push('slug:string:uniq', 'lock_version:integer', 'deleted_at:datetime:index')
        .push(('sti_type:string' if abstract?))
        .compact
        .map(&:to_s)

      def spec_interpolations = super.merge(
        attribute: attribute.try(:name) || attribute,
        target: target.try(:name) || target
      )
    end
  end
end
