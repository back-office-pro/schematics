# frozen_string_literal: true

Schematics::LinkPreview::Popover::SLIM = <<~SLIM
  .m-2
    = __attachment(attachment: image, height: 100, class: 'float-start me-2 rounded') if image.attached?
    h5.text-primary = title
    .text-body-tertiary = description
SLIM
