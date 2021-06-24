# frozen_string_literal: true

require 'schematics/attributes/attribute'
require 'schematics/attributes/address'
require 'schematics/attributes/association'
require 'schematics/attributes/attachment'
require 'schematics/attributes/attachments'
require 'schematics/attributes/belongs_to'
require 'schematics/attributes/boolean'
require 'schematics/attributes/country'
require 'schematics/attributes/date'
require 'schematics/attributes/datetime'
require 'schematics/attributes/decimal'
require 'schematics/attributes/digest'
require 'schematics/attributes/email'
require 'schematics/attributes/enum'
require 'schematics/attributes/float'
require 'schematics/attributes/integer'
require 'schematics/attributes/jsonb'
require 'schematics/attributes/phone'
require 'schematics/attributes/references'
require 'schematics/attributes/rich_text'
require 'schematics/attributes/string'
require 'schematics/attributes/text'
require 'schematics/attributes/time_zone'
require 'schematics/attributes/time'
require 'schematics/attributes/timestamp'
require 'schematics/attributes/token'
require 'schematics/attributes/url'
require 'schematics/entities/descriptor'
require 'schematics/entities/options_struct'
require 'schematics/virtuals/virtual'
require 'schematics/virtuals/comparison'
require 'schematics/virtuals/concatenation'
require 'schematics/virtuals/calculation'
require 'schematics/associations/association'
require 'schematics/associations/has_and_belongs_to_many'
require 'schematics/associations/has_many_through'
require 'schematics/associations/has_many'
require 'schematics/associations/has_one_through'
require 'schematics/associations/has_one'
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

        def active_storage_attachment(name:, icon:)
          create(
            name: name,
            icon: icon,
            descriptor: 'filename',
            attributes: [
              {
                name: 'filename',
                type: 'string',
              },
              {
                name: 'content_type',
                type: 'string',
              },
              {
                name: 'byte_size',
                type: 'float',
                options: {
                  unit: 'bytes',
                },
              },
            ]
          )
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
        Schematics.const_defined?(mod) && Schematics.const_get(mod).const_defined?(constant) ||
          Behaviours.const_defined?(constant) ||
          super
      end

      def find_field_by_name(name)
        case name
        when 'created_at'
          Attributes::Attribute.created_at(self)
        when 'id'
          Attributes::Attribute.id(self)
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
        return :inbox unless timestamp_attributes.size.zero?
        return :calendar if datetime_attributes.size >= 2
        return :grid if attachment_attributes.any?(&:image?)

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
        <<~RUBY
          resources :#{name.pluralize} do
            member do
              get :delete
              delete :archive
              delete :restore
            end
            collection do
              post :bulk_insert
              get :import
              get :autocomplete
            end
          end
        RUBY
      end

      def to_str
        <<~RUBY
          extend Pagy::Searchkick
          has_paper_trail ignore: %i[id created_at updated_at deleted_at read_at slug],
                          versions: { class_name: 'Schematics::Version' }
          acts_as_paranoid
          searchkick searchable: #{elasticsearchable_elements},
                     filterable: #{elasticsearchable_elements},
                     word_middle: #{elasticsearchable_elements},
                     suggest: #{elasticsearchable_elements},
                     callbacks: :async
        RUBY
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

      def elasticsearchable_elements
        searchable_elements
          .map(&:name)
          .map(&:to_sym)
      end

      def search_data_elements
        searchable_elements
          .map { |element| "#{element.name}: #{element.search_data.squish}" }
          .join(", \n")
      end

      def virtual_association_errors
        virtual_associations = association_attributes
                               .concat(associations)
                               .map(&:name)
                               .map(&:to_sym)
        virtuals
          .flat_map(&:preload)
          .uniq
          .reject { |association| virtual_associations.include?(association) }
      end
    end
  end
end
