# frozen_string_literal: true

class SchemaEditorOptionsEventsInput < SimpleForm::Inputs::StringInput
  def input(_wrapper_options)
    Schematics::SchemaEditor::Options::Events::Component
      .new(builder: @builder)
      .to_html
      .html_safe # rubocop:disable Rails/OutputSafety
  end
end
