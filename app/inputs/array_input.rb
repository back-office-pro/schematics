# frozen_string_literal: true

class ArrayInput < SimpleForm::Inputs::StringInput
  def input(wrapper_options)
    input_html_options[:type] ||= :text
    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)
    Schematics::Input::Array::Component
      .new(builder: @builder, object_name:, attribute_name:, merged_input_options:)
      .to_html
      .html_safe # rubocop:disable Rails/OutputSafety
  end
end
