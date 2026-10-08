# frozen_string_literal: true

Schematics::AttachmentValidator::AntivirusMissing::SLIM = <<~SLIM
  .mt-1.text-danger
    = fa_icon icon, class: 'me-1'
    = title
SLIM
