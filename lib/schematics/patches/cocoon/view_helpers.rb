# frozen_string_literal: true

module Schematics
  module Patches
    module Cocoon
      module ViewHelpers
        def create_object(form, association, force_non_association_create = false) # rubocop:disable Style/OptionalBooleanParameter
          return super if form.object.class.respond_to?(:reflect_on_association)

          create_object_on_non_association(form, association)
        end

        def link_to_remove_association(*args, &)
          if block_given?
            link_to_remove_association(capture(&), *args)
          elsif args.first.respond_to?(:object)
            form = args.first
            association = form.object.class.to_s.tableize
            default = ::I18n.t('cocoon.defaults.remove')
            name = ::I18n.t("cocoon.#{association}.remove", default:)

            link_to_remove_association(name, *args)
          else
            name, _form, html_options = *args
            html_options ||= {}

            classes = %w[remove_fields dynamic]
            html_options[:class] = [html_options[:class], classes.join(' ')].compact.join(' ')

            wrapper_class = html_options.delete(:wrapper_class)
            html_options[:'data-wrapper-class'] = wrapper_class if wrapper_class.present?

            link_to(name, '#', html_options)
          end
        end

        def render_association( # rubocop:disable Metrics/ParameterLists
          association,
          form,
          new_object,
          _form_name,
          _received_render_options,
          custom_partial = nil
        )
          partial = get_partial_path(custom_partial, association)
          options = { child_index: "new_#{association}" }
          form.simple_fields_for association, new_object, options do |builder|
            render partial.new(builder:)
          end
        end
      end
    end
  end
end
