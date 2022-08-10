# frozen_string_literal: true

class ArrayInput < SimpleForm::Inputs::StringInput
  def input(wrapper_options)
    input_html_options[:type] ||= :text
    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)
    Array(object.public_send(attribute_name)).map do |value|
      name = "#{object_name}[#{attribute_name}][]"
      @builder.text_field nil, merged_input_options.merge(value:, name:)
    end.join.html_safe # rubocop:disable Rails/OutputSafety
  end
end
