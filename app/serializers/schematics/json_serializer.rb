# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class JSONSerializer
    include ResourcesHelper

    delegate :class, to: :@resource, prefix: :model, private: true
    delegate :attachable_sgid, to: :@resource, private: true
    delegate :entity, to: :model_class, private: true
    delegate :descriptor,
             :icon,
             :renderable_elements,
             :renderable_elements_without_has_many_associations,
             :find_field_by_name,
             to: :entity,
             private: true

    def initialize(resource, options)
      @resource = resource
      @options = options || {}
    end

    memoize def content = elements
      .stable_sort_by(&:weight)
      .to_h(&method(:element_to_array))
      .merge(metadata)

    private

    def metadata
      return {} unless metadata?

      {
        _metadata: {
          icon: icon.to_s.dasherize,
          descriptor: @resource.to_s,
          url: resource_path(@resource),
          sgid: attachable_sgid
        }
      }
    end

    def metadata? = @options[:metadata]

    def association? = @options[:association]

    def expand? = @options[:expand]

    def show?
      @options[:template] == 'show'
    end

    def elements
      return association_elements if association?
      return renderable_elements if show? && !metadata?

      renderable_elements_without_has_many_associations
    end

    def association_elements = [
      find_field_by_name('id'),
      find_field_by_name(descriptor.name)
    ].uniq.reject(&:hidden?)

    def element_to_array(element) # rubocop:disable Metrics/CyclomaticComplexity
      [
        element.name,
        case element
        when Attributes::Attachments
          element.format(
            @resource
              .public_send(element.name.to_sym)
              .includes(element.includes)
              .then_tap { _1.accessible_by(@options[:ability]) if @options.key?(:ability) }
          )
        when Associations::HasMany, Associations::HasManyThrough, Associations::HasAndBelongsToMany
          @resource
            .public_send(element.name.to_sym)
            .includes(element.includes)
            .then_tap { _1.accessible_by(@options[:ability]) if @options.key?(:ability) }
            .limit(Loadable::ASSOCIATIONS_LIMIT)
            .order(created_at: :desc)
            .as_json(association: !expand?)
        when Attributes::Association, Associations::HasOne, Associations::HasOneThrough
          @resource
            .public_send(element.name.to_sym)
            .as_json(association: !expand?)
        when Attributes::Attachment, Attributes::RichText
          element.format @resource.public_send(element.name.to_sym)
        when Virtuals::Virtual
          @resource
            .public_send(element.name.to_sym)
            .then_tap { _1.try(:original_message) }
        else
          @resource.public_send(element.name.to_sym)
        end
      ]
    end
  end
end
