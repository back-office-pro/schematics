# frozen_string_literal: true

Schematics::Avatar::SLIM = <<~SLIM
  .position-relative.d-inline-block
    = __resource_link_to(resource: user) do |c|
      - c.with_body do
        = __attachment(:avatar, user:, title: user, **kwargs)
    .badge.rounded-circle.animate__animated.animate__zoomIn.d-block.p-1.position-absolute.top-0.end-0 class=badge_css_class
SLIM
