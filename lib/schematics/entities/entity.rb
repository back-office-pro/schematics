# frozen_string_literal: true

require 'active_record'
require 'active_record/attribute_methods'
require 'active_support/core_ext/array/access'
require 'active_support/core_ext/securerandom'
require 'active_support/core_ext/string/inflections'

module Schematics
  module Entities
    # :reek:Attribute, :reek:InstanceVariableAssumption
    class Entity # rubocop:disable Metrics/ClassLength
      include ::ActiveModel::API

      MISSING_REGEX = /(non_)?([a-zA-Z_]+)_(attributes|virtuals|associations|fields|elements)/
      NAME_REGEX = %r{\A([a-z_/]+)\z}
      CALENDAR_START = :start_at
      CALENDAR_END = :end_at

      validates :attributes, presence: true
      validates :actions, inclusion: { in: :default_actions }
      validates :name, english: true, unless: :core?
      validates :name,
                presence: true,
                singular: true,
                format: { with: NAME_REGEX, message: :name },
                length: { maximum: 50 },
                exclusion: { in: :reserved_names, message: :reserved_name }

      attr_accessor :schema, :name
      attr_writer :id, :options

      delegate :core?, :existing?, :hidden?, to: :options

      class << self
        def build(type: 'entity', **kwargs)
          Entities.const_get(type.camelize.to_sym).new(**kwargs)
        end
      end

      def attributes=(attributes)
        @attributes = attributes.map { Attributes::Attribute.build(entity: self, **_1) }
      end

      def virtuals=(virtuals)
        @virtuals = virtuals.map { Virtuals::Virtual.build(entity: self, **_1) }
      end

      def triggers=(triggers)
        @triggers = triggers.map { Trigger.new(**_1) }
      end

      def associations=(associations)
        @associations = associations.map { Associations::Association.build(entity: self, **_1) }
      end

      alias attributes_attributes= attributes=
      alias virtuals_attributes= virtuals=
      alias triggers_attributes= triggers=
      alias has_and_belongs_to_many_associations_attributes= associations=
      alias options_attributes= options=

      def descriptor
        Descriptor.new(entity: self, field_name: options.descriptor)
      end

      def actions
        options.actions&.map(&:to_sym) || default_actions
      end

      def options
        Options::Wrapper.new(options: @options)
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

      def id
        @id ||= SecureRandom.uuid
      end

      def weight = has_many_and_through_and_belongs_to_many_associations.size

      def fields = attributes + virtuals

      def elements = fields + associations

      def renderable_with_created_ats_fields = renderable_fields + created_at_attributes

      def to_str = ''

      # :reek:FeatureEnvy
      def method_missing(method_name, *, &) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
        non, constant, method = method_name.to_s.scan(MISSING_REGEX).flatten
        predicate = non ? :reject_is_a? : :select_is_a?
        constant = constant&.camelize&.to_sym
        mod = method&.camelize&.to_sym
        return super unless mod || constant

        elements = public_send(method.to_sym)
        if Schematics.const_defined?(mod) && Schematics.const_get(mod).const_defined?(constant)
          elements.public_send(predicate, Schematics.const_get(mod).const_get(constant))
        elsif Behaviours.const_defined?(constant)
          elements = elements.public_send(predicate, Behaviours.const_get(constant))
          case constant
          when :Migratable
            elements
          when :Fillable
            elements
              .reject(&:hidden?)
              .reject(&:readonly?)
          when :Listable, :Searchable
            elements
              .push(created_at_attribute)
              .reject(&:hidden?)
          when :Renderable
            elements
              .unshift(id_attribute)
              .push(created_at_attribute)
              .reject(&:hidden?)
          else
            elements.reject(&:hidden?)
          end
        end
      end

      def respond_to_missing?(method_name, *) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
        _non, constant, method = method_name.to_s.scan(MISSING_REGEX).flatten
        constant = constant&.camelize&.to_sym
        mod = method&.camelize&.to_sym
        return super unless mod || constant

        (Schematics.const_defined?(mod) && Schematics.const_get(mod).const_defined?(constant)) ||
          Behaviours.const_defined?(constant)
      end

      def find_field_by_name(name)
        fields
          .concat(created_at_attributes)
          .push(created_at_attribute)
          .push(id_attribute)
          .find { |field| field.name == name.to_s }
      end

      def find_attribute_by_id(id)
        attributes.find { _1.id == id }
      end

      def find_event_by_name(name)
        events.find { _1.name == name }
      end

      def check_for_association_name_collisions
        associations.each do |association|
          association.prefixed = associations
                                 .reject { _1 == association }
                                 .any? { _1.source == association.source }
        end
      end

      def permitted_params = fillable_elements
        .flat_map(&:permitted_params)
        .push(:lock_version)

      def permitted_json_params = fillable_elements
        .flat_map(&:permitted_json_params)
        .push(:lock_version)

      def includes = preloadable_elements
        .flat_map(&:preload)
        .compact
        .uniq

      def events
        state_machine_attributes.flat_map(&:events)
      end

      def validators
        validatable_attributes.filter_map(&:validators)
      end

      def has_many_and_through_and_belongs_to_many_associations # rubocop:disable Naming/PredicateName
        has_many_associations + has_many_through_associations + has_and_belongs_to_many_associations
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
        options.icon&.to_sym || :square_caret_right
      end

      def load
        context = binding.of_caller(1).method(:eval)
        model_elements.each(&context)
      end

      def viewer
        return :calendar if find_field_by_name(CALENDAR_START) && find_field_by_name(CALENDAR_END)
        return :grid if attachment_attributes.any?(&:image?)

        :table
      end

      def can?(action)
        actions.include?(action.to_sym)
      end

      def actions_with_events
        actions.concat(events.map(&:name))
      end

      def valid?(*) # rubocop:disable Metrics/CyclomaticComplexity
        valid = super && (fields + triggers).all?(&:valid?) && descriptor.valid?
        %i[attributes virtuals triggers has_and_belongs_to_many_associations].each do |element|
          public_send(element)
            .flat_map(&:errors)
            .flat_map(&:compact)
            .each { |error| errors.add(:"#{element}_attributes", error) }
        end
        errors.merge!(descriptor)
        valid
      end

      def default_actions = %i[index show create update destroy archive]

      def default
        model_class.new(**non_state_machine_attributes.to_h { [_1.name, _1.default] })
      end

      def router = Router.new(self)

      def association_elements = has_many_and_through_and_belongs_to_many_associations
        .reject(&:existing?)
        .to_a
        .concat(attachments_attributes)

      def search_aliases
        searchable_elements.map(&:search_alias)
      end

      protected

      def model_elements = [self, descriptor].concat(triggers, elements, validators, search_aliases)

      def id_attribute = Attributes::Uuid.new(entity: self, name: 'id')

      def created_at_attribute = Attributes::Datetime.new(entity: self, name: 'created_at')

      def created_at_attributes = [
        Attributes::Date.new(entity: self, name: 'created_at/day'),
        Attributes::Week.new(entity: self, name: 'created_at/week'),
        Attributes::Month.new(entity: self, name: 'created_at/month'),
        Attributes::Year.new(entity: self, name: 'created_at/year')
      ]

      def reserved_names = ::ActiveRecord::AttributeMethods
        .dangerous_attribute_methods
        .to_a
        .concat(schema.entities.excluding(self).map(&:name))
    end
  end
end
