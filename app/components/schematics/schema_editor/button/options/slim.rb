# frozen_string_literal: true

Schematics::SchemaEditor::Button::Options::SLIM = <<~SLIM
  .btn.btn-primary.btn-sm {
    data-controller='tooltip'
    data-bs-toggle='modal'
    data-bs-target=target
    data-bs-title=title
  } = fa_icon :gear
SLIM
