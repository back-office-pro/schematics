# frozen_string_literal: true

Schematics::AttachmentValidator::SLIM = <<~SLIM
  - if antivirus_missing?
    = __attachment_validator_antivirus_missing
  - else
    .mt-1
      = fa_icon icon, class: 'me-1'
      = @validator
SLIM
