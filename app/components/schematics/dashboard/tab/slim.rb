# frozen_string_literal: true

Schematics::Dashboard::Tab::SLIM = <<~SLIM
  li.nav-item
    button.nav-link.pt-0 class=css_classes data-bs-toggle='pill' data-bs-target=target type='button' role='tab'
      = fa_icon(icon, class: 'me-2') if icon
      = title
SLIM
