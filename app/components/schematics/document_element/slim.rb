# frozen_string_literal: true

Schematics::DocumentElement::SLIM = <<~SLIM
  html lang=locale dir='ltr' data-bs-theme=theme class=css_classes
    = __head
    = content
SLIM
