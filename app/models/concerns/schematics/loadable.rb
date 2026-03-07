# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

module Schematics
  module Loadable
    extend ActiveSupport::Concern

    ASSOCIATIONS_LIMIT = 100

    included do
      include ActiveStorageSupport::SupportForBase64
      include AASM

      attribute_method_suffix '_formatted'
      attribute :lock_version, default: 0
      broadcasts_refreshes
    end

    class_methods do
      delegate :abstract?, to: :entity, allow_nil: true
      # :reek:Attribute
      attr_accessor :concerns

      def inherited(subclass)
        super
        subclass.class_eval do
          superclass.concerns&.each(&method(:include))
          entity&.model_elements&.each do |model_element|
            eval model_element, binding, __FILE__, __LINE__ # rubocop:disable Security/Eval
          end
        end
      end

      def entity
        SchemaCache.find_entity_by_name(name.underscore)
      end

      def filter_attributes = entity
        .non_renderable_attributes
        .map(&:column_name)
        .map(&:to_sym)

      def cached_attributes = entity
        .attributes
        .select(&:cached?)
        .map(&:name)
        .map(&:to_sym)

      def finder(id)
        case entity
        when Entities::Singleton
          instance
        else
          friendly.find(id)
        end
      end

      def create_without_validations(resources)
        Array
          .wrap(resources)
          .map { |attributes| new(**attributes).tap { _1.save(validate: false) } }
      end

      def preload_all = includes(entity.includes).preload(entity.preload)

      def print_model
        print entity.model_elements.map(&:to_str).join # rubocop:disable Rails/Output
      end

      def load!(name)
        entity = SchemaCache.find_entity_by_name(name.to_s.underscore)
        return unless entity

        unless Object.const_defined?(name)
          Rails.logger.info "Loading #{name}..."
          path = Rails.root.join('app', 'models', 'core', "#{entity.name}.rb")

          if path.exist?
            load(path)
          else
            eval(entity, binding, __FILE__, __LINE__) # rubocop:disable Security/Eval
          end
        end

        const_get(name)
      end

      def find_sti_class(type_name)
        type_name.safe_constantize || super
      end

      private

      def loadable(concerns: [])
        self.concerns = concerns
      end
    end

    def attribute_formatted(attr)
      self
        .class
        .entity
        &.find_field_by_name(attr)
        &.format(public_send(attr)) || public_send(attr)
    end

    # :reek:BooleanParameter :reek:ControlParameter
    def associations(ability, dependent: false)
      self
        .class
        .entity
        .association_elements
        .then_tap { _1.grep_v(Associations::HasAndBelongsToMany).select(&:required?) if dependent }
        .map { public_send(_1.name).includes(_1.includes).with_string_translations }
        .map { _1.accessible_by(ability).order(created_at: :desc) }
        .map { _1.limit(ASSOCIATIONS_LIMIT) }
        .compact_blank
    end

    protected

    def raise_nested_attributes_record_not_found!(*) = nil
  end
end
