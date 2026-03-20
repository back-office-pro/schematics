# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

require 'active_support/core_ext/array/access'
require 'active_support/core_ext/securerandom'
require 'active_support/core_ext/string/inflections'

module Schematics
  module Entities
    # :reek:Attribute :reek:InstanceVariableAssumption :reek:TooManyMethods
    class Entity # rubocop:disable Metrics/ClassLength
      include Behaviours::Specifiable
      include Behaviours::Optionable
      include Behaviours::Nameable

      DEFAULT_ACTIONS = %i[index show create update destroy archive].freeze
      NAME_DENYLIST = %w[
        action_text_rich_text
        active_storage_attachment
        active_storage_blob
        active_storage_variant_record
        friendly_id_slug
        mobility_string_translation
        mobility_text_translation
        paper_trail_version
        solid_cable_message
        solid_cache_entry
        solid_queue_blocked_execution
        solid_queue_claimed_execution
        solid_queue_failed_execution
        solid_queue_job
        solid_queue_ready_execution
        solid_queue_recurring_execution
        solid_queue_recurring_task
        solid_queue_scheduled_execution
        solid_queue_semaphore
        solid_queue_pause
        solid_queue_process
      ].freeze

      accepts_nested_attributes_for :attributes
      accepts_nested_attributes_for :virtuals
      accepts_nested_attributes_for :triggers
      accepts_nested_attributes_for :has_and_belongs_to_many_associations

      validates_associated :attributes
      validates_associated :virtuals
      validates_associated :triggers
      validates_associated :has_and_belongs_to_many_associations
      validates_associated :descriptor

      validates :actions, inclusion: { in: self::DEFAULT_ACTIONS }
      validates :name, singular: true, uniqueness: { scope: %i[schema entities] }
      validates :icon, inclusion: { in: Options::Icon.collection }
      validates :parent, allow_nil: true, inclusion: { in: :allowed_parent_entities }

      attr_accessor :id, :schema

      delegate :core?, :existing?, :parent, to: :options
      delegate :method_missing, :receptor_respond_to_missing?, to: :receptor, private: true

      class << self
        def build(type: 'entity', **)
          Entities.const_get(type.camelize.to_sym).new(**)
        end

        def to_proc = -> { build(**_1) }
      end

      def attributes=(attributes)
        @attributes = attributes
          .each_with_object(entity: self)
          .map(&:merge)
          .map(&Attributes::Attribute)
      end

      def virtuals=(virtuals)
        @virtuals = virtuals
          .each_with_object(entity: self)
          .map(&:merge)
          .map(&Virtuals::Virtual)
      end

      def triggers=(triggers)
        @triggers = triggers
          .each_with_object(entity: self)
          .map(&:merge)
          .map(&Triggers::Trigger)
      end

      def associations=(associations)
        @associations = associations
          .each_with_object(entity: self)
          .map(&:merge)
          .map(&Associations::Association)
      end

      def descriptor
        Descriptor.new(entity: self, field_name: options.descriptor)
      end

      def actions
        options.actions&.map(&:to_sym) || self.class::DEFAULT_ACTIONS
      end

      def associations
        @associations ||= []
      end

      def attributes
        @attributes ||= []
      end

      def virtuals
        @virtuals ||= []
      end

      def triggers
        @triggers ||= []
      end

      def available_options = [
        Options::Core,
        Options::Hidden,
        Options::Existing,
        Options::Descriptor.new(collection: descriptor.allowed_field_names),
        Options::Actions.new(collection: self.class::DEFAULT_ACTIONS),
        Options::Parent.new(collection: allowed_parent_entities),
        Options::Icon
      ]

      def weight = has_many_and_through_and_belongs_to_many_associations.size

      def fields = attributes + virtuals

      def parent_fields_and_children_attributes
        return fields unless parent

        parent_entity
          .fields
          .concat(parent_entity.children.flat_map(&:attributes))
      end

      def parent_and_children_has_and_belongs_to_many_associations
        return has_and_belongs_to_many_associations unless parent

        parent_entity
          .has_and_belongs_to_many_associations
          .concat(parent_entity.children.flat_map(&:has_and_belongs_to_many_associations))
      end

      def elements = fields + associations

      def renderable_with_created_ats_fields = renderable_fields + created_at_attributes

      def renderable_elements_without_has_many_associations
        renderable_elements.excluding(has_many_and_through_and_belongs_to_many_associations)
      end

      def respond_to_missing?(method_name, *)
        receptor_respond_to_missing?(method_name) || super
      end

      def find_field_by_name(name)
        fields
          .concat(created_at_attributes)
          .push(created_at_attribute)
          .push(id_attribute)
          .find { |field| field.name == name.to_s }
      end

      def find_event_by_name(name)
        events.find { _1.name == name }
      end

      def find_event_by_suffixed_name(name)
        events.find { _1.suffixed_name == name }
      end

      def permitted_params = fillable_elements
        .grep_v(Attributes::User)
        .flat_map(&:permitted_params)
        .push(:lock_version)

      def permitted_json_params = fillable_elements
        .flat_map(&:permitted_json_params)
        .push(:lock_version)

      def enum_values
        enum_attributes.flat_map(&:enum_values)
      end

      def events
        state_machine_attributes.flat_map(&:events)
      end

      def validators
        validatable_elements.filter_map(&:validators)
      end

      def class_name
        name.camelize
      end

      def model_class
        class_name.safe_constantize
      end

      def table_name
        name.tr('/', '_')
      end

      def icon
        options.icon&.to_sym || :circle_nodes
      end

      def can?(action)
        actions.include?(action.to_sym) && !abstract?
      end

      def child?
        parent.present?
      end

      def abstract?
        children.any?
      end

      def actions_with_events
        actions + events.map(&:name)
      end

      def default = model_class.new(
        **non_state_machine_attributes
          .concat(has_and_belongs_to_many_associations.reject(&:hidden?))
          .to_h { [_1.name, _1.default] }
      )

      def default_associations = belongs_to_attributes
        .concat(has_and_belongs_to_many_associations.reject(&:hidden?))
        .filter_map(&:default)
        .flatten

      def joins = virtuals
        .flat_map(&:preload)
        .compact
        .uniq

      def includes = preloadable_elements
        .grep_v(Associations::HasMany)
        .grep_v(Associations::HasManyThrough)
        .flat_map(&:preload)
        .excluding(preload)
        .compact
        .uniq

      def preload = association_attributes
        .select(&:polymorphic?)
        .flat_map(&:preload)
        .compact
        .uniq

      def to_str = <<~RUBY
        class ::#{class_name} < #{parent_class_name}; end
      RUBY

      def digest = Digest::MD5.hexdigest(
        model_elements
          .concat(children.flat_map(&:model_elements))
          .map(&:to_str)
          .join
      )

      def association_elements = has_many_and_through_and_belongs_to_many_associations
        .reject(&:existing?)
        .to_a
        .concat(attachments_attributes)

      def search_aliases
        searchable_elements.map(&:search_alias)
      end

      def model_elements = elements
        .concat(triggers, validators, search_aliases)
        .push(descriptor)

      def start_date_attribute_name = date_attributes
        .find(&:start_date?)
        &.name
        &.to_sym

      def end_date_attribute_name = date_attributes
        .find(&:end_date?)
        &.name
        &.to_sym

      def id_attribute = Attributes::Uuid.new(
        entity: self,
        name: 'id',
        options: { readonly: true }
      )

      def created_at_attribute = Attributes::Datetime.new(
        entity: self,
        name: 'created_at',
        options: { readonly: true }
      )

      def open_api_body = { name.to_sym => fillable_elements.to_h(&:to_open_api_body) }

      def open_api_schema_with_associations = renderable_elements
        .stable_sort_by(&:weight)
        .to_h(&:to_open_api_schema)

      def open_api_schema = renderable_elements_without_has_many_associations
        .stable_sort_by(&:weight)
        .to_h(&:to_open_api_schema)

      def source_entity
        parent_entity || self
      end

      def parent_entity
        schema.find_entity_by_name(parent)
      end

      def children = schema
        .entities
        .select { _1.parent_entity == self }

      def migratable_attributes = super
        .concat(children.flat_map(&:migratable_attributes))
        .push((slug_attribute unless child?))
        .push((lock_version_attribute unless child?))
        .push((deleted_at_attribute unless child?))
        .push((sti_type_attribute if abstract?))
        .compact

      protected

      def allowed_parent_entities = schema
        .entities
        .excluding(self)
        .reject(&:hidden?)
        .reject(&:child?)
        .reject(&:core?)
        .map(&:name)
        .sort

      def has_many_and_through_and_belongs_to_many_associations # rubocop:disable Naming/PredicatePrefix
        has_many_associations + has_many_through_associations + has_and_belongs_to_many_associations
      end

      def created_at_attributes = [
        Attributes::Date.new(entity: self, name: 'created_at/day'),
        Attributes::Week.new(entity: self, name: 'created_at/week'),
        Attributes::Month.new(entity: self, name: 'created_at/month'),
        Attributes::Year.new(entity: self, name: 'created_at/year')
      ]

      def parent_class_name
        return 'Schematics::ApplicationRecord' unless parent

        "::#{parent_entity&.class_name}"
      end

      def slug_attribute = Attributes::String.new(
        entity: self,
        name: 'slug',
        options: { unique: true, readonly: true }
      )

      def lock_version_attribute = Attributes::Integer.new(
        entity: self,
        name: 'lock_version',
        options: { readonly: true }
      )

      def deleted_at_attribute = Attributes::Datetime.new(
        entity: self,
        name: 'deleted_at',
        options: { readonly: true }
      )

      def sti_type_attribute = Attributes::String.new(
        entity: self,
        name: 'sti_type',
        options: { readonly: true }
      )

      def receptor = Receptor.new(self)

      def spec_interpolations = { name: name.pluralize }
    end
  end
end
