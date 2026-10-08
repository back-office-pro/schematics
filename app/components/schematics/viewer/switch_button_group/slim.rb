# frozen_string_literal: true

Schematics::Viewer::SwitchButtonGroup::SLIM = <<~SLIM
  .form-check.form-switch.w-0.mb-0.align-self-center
    = checkbox_tag id, '', false, data:, class: 'form-check-input'
    = label_tag id, '', class: 'form-check-label'
SLIM
