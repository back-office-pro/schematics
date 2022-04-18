# frozen_string_literal: true

require 'simple_form/components/input_group'

# Make sure we override main app initializers config
Rails.configuration.after_initialize do
  SimpleForm::FormBuilder.map_type :inet, to: SimpleForm::Inputs::StringInput
  SimpleForm.include_component SimpleForm::Components::InputGroup
  SimpleForm.setup do |config|
    config.input_class = 'border-0 p-2'
    config.wrapper_mappings = { boolean: :custom_boolean_switch }
    config.wrappers :edit_in_place_form, class: 'row w-100' do |b|
      b.use :html5
      b.use :placeholder
      b.optional :maxlength
      b.optional :minlength
      b.optional :pattern
      b.optional :min_max
      b.optional :readonly
      b.wrapper :grid_wrapper, class: 'col-sm-12' do |ba|
        ba.use :input, class: 'form-control form-control-sm px-2 py-0',
                       error_class: 'is-invalid',
                       valid_class: 'is-valid'
        ba.use :full_error, wrap_with: { class: 'invalid-feedback' }
        ba.use :hint, wrap_with: { class: 'form-text' }
      end
    end
  end
end
