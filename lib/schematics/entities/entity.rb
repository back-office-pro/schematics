# frozen_string_literal: true

require 'active_support/core_ext/string/inflections'

module Schematics
  module Entities
    class Entity
      attr_reader :name,
                  :icon,
                  :descriptor,
                  :attributes,
                  :virtuals,
                  :associations

      MISSING_REGEX = /(non_)?([a-zA-Z_]+)_(attributes|virtuals|associations|fields|elements)/

      class << self
        # :reek:LongParameterList
        def create(name:,
                   type: nil,
                   icon: :caret_square_right,
                   descriptor: 'id',
                   associations: [],
                   attributes: [],
                   virtuals: [])
          args = [name, icon.to_sym, descriptor, associations, attributes, virtuals]
          return new(*args) unless type

          Entities.const_get(type.camelize.to_sym).new(*args)
        end
      end

      # :reek:LongParameterList
      def initialize(name, icon, descriptor, associations, attributes, virtuals)
        @name = name
        @icon = icon
        @associations = associations.map do |association|
          Associations::Association.create(self, **association)
        end
        @attributes = attributes.map { |attribute| Attributes::Attribute.create(self, **attribute) }
        @virtuals = virtuals.map { |virtual| Virtuals::Virtual.create(self, **virtual) }
        @descriptor = Descriptor.create(self, descriptor)
      end

      def method_missing(method_name, *args, &block) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
        non, constant, method = method_name.to_s.scan(MISSING_REGEX).flatten
        predicate = non ? :reject_is_a? : :select_is_a?
        constant = constant&.camelize&.to_sym
        mod = method&.camelize&.to_sym
        if Schematics.const_defined?(mod) && Schematics.const_get(mod).const_defined?(constant)
          send(method.to_sym).send(predicate, Schematics.const_get(mod).const_get(constant))
        elsif Behaviours.const_defined?(constant)
          case constant
          when :Migratable
            send(method.to_sym).send(predicate, Behaviours::Migratable)
          when :Fillable
            send(method.to_sym)
              .send(predicate, Behaviours::Fillable)
              .reject(&:hidden?)
              .reject(&:readonly?)
          else
            send(method.to_sym)
              .send(predicate, Behaviours.const_get(constant))
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
          Attributes::Date.new(self, 'created_at', required: true)
        when 'id'
          Attributes::Uuid.new(self, 'id', unique: true)
        else
          fields.find { |field| field.name == name }
        end
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
        fillable_elements.flat_map(&:permitted_params)
      end

      def permitted_json_params
        fillable_elements.flat_map(&:permitted_json_params)
      end

      def includes
        preloadable_elements
          .flat_map(&:preload)
          .compact
          .uniq - virtual_association_errors
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

      def load
        context = binding.of_caller(1).method(:eval)
        model_elements.each(&context)
      end

      def viewer
        return :inbox if timestamp_attributes.any?
        return :calendar if datetime_attributes.size >= 2
        return :grid if attachment_attributes.any?

        :table
      end

      def search_data
        <<~RUBY
          def search_data
            {
              created_at: created_at,
              #{search_data_elements}
            }
          end
        RUBY
      end

      def route
        resource, namespace = name.split('/').reverse

        route = <<~RUBY
          resources :#{resource.pluralize}, model_name: '#{class_name}' do
            member do
              get :delete
              delete :archive
              delete :restore
            end
            collection do
              get :autocomplete
              resources :imports, only: %i[new create], as: '#{resource}_imports', format: false do
                get :template, on: :collection, format: :csv
              end
            end
          end
        RUBY

        return route unless namespace

        <<~RUBY
          namespace :#{namespace} do
            #{route}
          end
        RUBY
      end

      def to_str
        ''
      end

      def to_s
        <<~RUBY
          class #{class_name}
            #{to_str}

            ###
            #{attributes.map { |attribute| "# #{attribute}" }.join("\n\s\s")}
            # #{permitted_params.join(', ')}
            # #{permitted_json_params.join(', ')}
            ###

            #{descriptor.to_str}
            #{validates.join("\s\s")}
            #{search_data}
            #{attributes.map(&:to_str).join("\s\s")}
            #{associations.map(&:to_str).join("\s\s")}
            #{virtuals.map(&:to_str).join("\s\s")}
          end
        RUBY
      end

      protected

      def model_elements
        [self, descriptor, search_data] + elements + validates
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
