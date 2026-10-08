# frozen_string_literal: true

Schematics::ResourceForm::Fields::Array::SLIM = <<~SLIM
  = form.select name.to_sym,
                collection,
                { prepend:, prompt:, include_hidden:, hide_label: },
                { multiple:, data:, control_class: }
SLIM
