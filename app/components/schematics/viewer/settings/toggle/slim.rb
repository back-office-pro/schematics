# frozen_string_literal: true

Schematics::Viewer::Settings::Toggle::SLIM = <<~SLIM
  .dropdown-item
    .form-check.form-switch.mb-0 data-action='input->viewer-settings#toggleColumn'
      = checkbox 'user[preferences]', preference, { class: 'form-check-input', id: preference, checked: checked? }, '', ''
      = label_tag preference, label, class: 'form-check-label float-start', for: preference
SLIM
