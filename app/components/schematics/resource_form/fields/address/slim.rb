# frozen_string_literal: true

Schematics::ResourceForm::Fields::Address::SLIM = <<~SLIM
  = form.select name.to_sym,
                collection,
                { prepend:, prompt:, hide_label: },
                { data:, autocomplete:, control_class: }
SLIM
