# frozen_string_literal: true

require 'active_support/core_ext/string/inflections'

module Schematics
  module Entities
    class Entity # rubocop:disable Metrics/ClassLength
      attr_reader :name,
                  :icon,
                  :descriptor,
                  :actions,
                  :attributes,
                  :virtuals,
                  :triggers,
                  :associations

      MISSING_REGEX = /(non_)?([a-zA-Z_]+)_(attributes|virtuals|associations|fields|elements)/

      class << self
        # :reek:LongParameterList
        def build( # rubocop:disable Metrics/ParameterLists
          name:,
          type: nil,
          icon: :caret_square_right,
          descriptor: 'id',
          core: false,
          actions: nil,
          associations: [],
          attributes: [],
          virtuals: [],
          triggers: []
        )
          args = [
            name,
            icon.to_sym,
            descriptor,
            core,
            actions,
            associations,
            attributes,
            virtuals,
            triggers
          ]
          return new(*args) unless type

          Entities.const_get(type.camelize.to_sym).new(*args)
        end
      end

      # :reek:LongParameterList
      def initialize( # rubocop:disable Metrics/ParameterLists
        name,
        icon,
        descriptor,
        core,
        actions,
        associations,
        attributes,
        virtuals,
        triggers
      )
        @name = name
        @icon = icon
        @core = core
        @actions = (actions || default_actions).map(&:to_sym)
        @associations = associations.map { Associations::Association.build(self, **_1) }
        @attributes = attributes.map { Attributes::Attribute.build(self, **_1) }
        @virtuals = virtuals.map { Virtuals::Virtual.build(self, **_1) }
        @triggers = triggers.map { Trigger.new(**_1) }
        @descriptor = Descriptor.build(self, descriptor)
      end

      def method_missing(method_name, *args, &) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
        non, constant, method = method_name.to_s.scan(MISSING_REGEX).flatten
        predicate = non ? :reject_is_a? : :select_is_a?
        constant = constant&.camelize&.to_sym
        mod = method&.camelize&.to_sym
        if Schematics.const_defined?(mod) && Schematics.const_get(mod).const_defined?(constant)
          public_send(method.to_sym)
            .public_send(predicate, Schematics.const_get(mod).const_get(constant))
        elsif Behaviours.const_defined?(constant)
          case constant
          when :Migratable
            public_send(method.to_sym).public_send(predicate, Behaviours::Migratable)
          when :Fillable
            public_send(method.to_sym)
              .public_send(predicate, Behaviours::Fillable)
              .reject(&:hidden?)
              .reject(&:readonly?)
          else
            public_send(method.to_sym)
              .public_send(predicate, Behaviours.const_get(constant))
              .reject(&:hidden?)
          end
        else
          super
        end
      end

      def respond_to_missing?(method_name, *args) # rubocop:disable Metrics/CyclomaticComplexity
        _non, constant, method = method_name.to_s.scan(MISSING_REGEX).flatten
        constant = constant&.camelize&.to_sym
        mod = method&.camelize&.to_sym
        (Schematics.const_defined?(mod) && Schematics.const_get(mod).const_defined?(constant)) ||
          Behaviours.const_defined?(constant) ||
          super
      end

      def find_field_by_name(name)
        case name
        when 'created_at'
          Attributes::Datetime.new(self, 'created_at', required: true)
        when 'id'
          Attributes::Uuid.new(self, 'id', unique: true)
        else
          fields.find { |field| field.name == name }
        end
      end

      def find_event_by_name(name)
        events.find { _1.name == name }
      end

      def check_for_association_name_collisions
        @associations.each do |association|
          association.prefixed = @associations
                                 .reject { _1 == association }
                                 .any? { _1.source == association.source }
        end
      end

      def weight
        has_many_and_through_and_belongs_to_many_associations.size
      end

      def fields
        @attributes + @virtuals
      end

      def elements
        fields + associations
      end

      def permitted_params
        fillable_elements
          .flat_map(&:permitted_params)
          .push(:lock_version)
      end

      def permitted_json_params
        fillable_elements
          .flat_map(&:permitted_json_params)
          .push(:lock_version)
      end

      def includes
        preloadable_elements
          .flat_map(&:preload)
          .compact
          .uniq - virtual_association_errors
      end

      def events
        state_machine_attributes.flat_map(&:events)
      end

      def validates
        validatable_attributes.filter_map(&:validate)
      end

      def has_many_and_through_and_belongs_to_many_associations # rubocop:disable Naming/PredicateName
        has_many_associations + has_many_through_associations + has_and_belongs_to_many_associations
      end

      def class_name
        name.camelize
      end

      def table_name
        name.tr('/', '_')
      end

      def core?
        @core
      end

      def load
        context = binding.of_caller(1).method(:eval)
        model_elements.each(&context)
      end

      def viewer
        return :calendar if datetime_attributes.size >= 2
        return :grid if attachment_attributes.any?(&:image?)

        :table
      end

      def can?(action)
        actions.include?(action.to_sym)
      end

      def search_data
        <<~RUBY
          def search_data
            {
              created_at:,
              #{search_data_elements}
            }
          end
        RUBY
      end

      def to_str
        ''
      end

      protected

      def default_actions
        %w[index show create new edit update destroy archive import]
      end

      def model_elements
        [self, descriptor, search_data] + elements + triggers + validates
      end

      def search_data_elements
        searchable_elements
          .map { |element| "#{element.name}: #{element.search_data.squish}" }
          .join(", \n")
      end

      def virtual_association_errors
        virtuals
          .flat_map(&:preload)
          .uniq
          .reject do |association|
            association_attributes
              .concat(associations)
              .map(&:name)
              .map(&:to_sym)
              .include?(association)
          end
      end
    end
  end
end
