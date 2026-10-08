# frozen_string_literal: true

Schematics::ResourceForm::Fields::BelongsTo::SLIM = <<~SLIM
  = form.select column_name.to_sym,
                collection,
                { prepend:, prompt:, label: },
                { data:, required: }
SLIM
