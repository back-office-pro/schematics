# frozen_string_literal: true

Schematics::ResourceForm::Fields::ModelField::SLIM = <<~SLIM
  = form.select name.to_sym,
                collection,
                { prepend:, hide_label:, prompt: },
                { data:, required:, control_class: }
SLIM
