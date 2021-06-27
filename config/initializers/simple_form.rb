# frozen_string_literal: true

require 'simple_form/components/input_group'

# Make sure we override main app initializers config
Rails.configuration.after_initialize do
  SimpleForm.include_component(SimpleForm::Components::InputGroup)
  SimpleForm.setup do |config|
    config.input_class = 'bg-light border-0 px-2'
    config.wrapper_mappings = {
      boolean: :custom_boolean_switch,
      check_boxes: :custom_collection,
      date: :custom_multi_select,
      datetime: :custom_multi_select,
      file: :custom_file,
      radio_buttons: :custom_collection,
      range: :custom_range,
      time: :custom_multi_select
    }
    config.wrappers :input_group,
                    tag: 'div',
                    class: 'form-group',
                    error_class: 'form-group-invalid',
                    valid_class: 'form-group-valid' do |b|
      b.use :html5
      b.use :placeholder
      b.optional :maxlength
      b.optional :minlength
      b.optional :pattern
      b.optional :min_max
      b.optional :readonly
      b.use :label
      b.wrapper :input_group_tag, tag: 'div', class: 'input-group' do |ba|
        ba.optional :prepend
        ba.use :input, class: 'form-control', error_class: 'is-invalid', valid_class: 'is-valid'
        ba.optional :append
      end
      b.use :full_error, wrap_with: { tag: 'div', class: 'invalid-feedback d-block' }
      b.use :hint, wrap_with: { tag: 'small', class: 'form-text text-muted' }
    end
  end
end
