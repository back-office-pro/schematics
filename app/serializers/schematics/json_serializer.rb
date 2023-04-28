# frozen_string_literal: true

module Schematics
  class JsonSerializer
    delegate :class, to: :@resource, prefix: :model, private: true
    delegate :attachable_sgid, to: :@resource, private: true
    delegate :entity, to: :model_class, private: true
    delegate :descriptor,
             :icon,
             :renderable_elements,
             :has_many_and_through_and_belongs_to_many_associations,
             :find_field_by_name,
             to: :entity, private: true

    def initialize(resource, options)
      @resource = resource
      @options = options || {}
    end

    def content = elements
      .stable_sort_by(&:weight)
      .to_h(&method(:foo))
      .merge(metadata)

    def metadata
      return {} unless metadata?

      {
        'Metadata' => {
          'icon' => icon.to_s.dasherize,
          'descriptor' => @resource.to_s,
          'url' => Rails.application.routes.url_helpers.polymorphic_path(@resource),
          'sgid' => attachable_sgid
        }
      }
    end

    def metadata? = @options[:metadata]

    def association? = @options[:association]

    def show?
      @options[:template] == 'show'
    end

    def elements
      return [find_field_by_name('id'), find_field_by_name(descriptor.name)].reject(&:hidden?) if association?
      return renderable_elements if show?

      renderable_elements.excluding(has_many_and_through_and_belongs_to_many_associations)
    end

    def foo(element)
      [
        element.name.camelize(:lower),
        case element
        when Attributes::Attachment, Attributes::RichText
          element.format @resource.public_send(element.name.to_sym)
        when Attributes::Association, Associations::Association
          @resource
            .public_send(element.name.to_sym)
            .as_json(association: true)
        else
          @resource.public_send(element.name.to_sym)
        end
      ]
    end
  end
end
