# frozen_string_literal: true

require 'simple_form/components/input_group'

# Make sure we override main app initializers config
Rails.configuration.after_initialize do
  SimpleForm.include_component(SimpleForm::Components::InputGroup)
  SimpleForm.setup do |config|
    config.input_class = 'bg-light border-0 p-2'
    config.wrapper_mappings = { boolean: :custom_boolean_switch }
  end
end
