# frozen_string_literal: true

Schematics::ResourceForm::Fields::Flag::SLIM = <<~SLIM
  = form.select name.to_sym,
                collection,
                { prepend:, hide_label:, prompt:, include_hidden: },
                { multiple:, data:, required:, control_class: }
SLIM
