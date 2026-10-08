# frozen_string_literal: true

Schematics::Placeholder::SLIM = <<~SLIM
  p.card-text.placeholder-glow class=css_classes
    - size.times do
      - cols.times do
        span.placeholder.bg-body-tertiary.rounded class=col_class
SLIM
