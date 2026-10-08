# frozen_string_literal: true

Schematics::LinkPreview::SLIM = <<~SLIM
  = link_to url, class: 'text-decoration-none', target: '_blank', rel: 'noreferrer', data: do
    = __attachment(attachment: image, height: 18, class: 'float-start me-2 rounded') if image.attached?
    = title
SLIM
