# frozen_string_literal: true

Schematics::ResourceForm::Fields::HasAndBelongsToMany::SLIM = <<~SLIM
  = form.select column_name.to_sym,
                collection,
                { prepend:, prompt:, include_hidden:, label:, required:, hide_label: },
                { multiple:, data:, required:, control_class: }
SLIM
