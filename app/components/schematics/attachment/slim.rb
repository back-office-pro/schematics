# frozen_string_literal: true

Schematics::Attachment::SLIM = <<~SLIM
  - begin
    = image_tag attachment, data:, **@kwargs
  - rescue StandardError
    = fa_icon icon, size:, data:, **@kwargs
SLIM
