# frozen_string_literal: true

Schematics::DeleteAlert::SLIM = <<~SLIM
  .alert.alert-danger
    h5.alert-heading
      = fa_icon icon, class: 'me-3'
      = title
    = text
SLIM
