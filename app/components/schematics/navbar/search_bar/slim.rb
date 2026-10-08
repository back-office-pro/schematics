# frozen_string_literal: true

Schematics::Navbar::SearchBar::SLIM = <<~SLIM
  li.nav-item.d-flex.align-items-center.px-2.ms-2.bg-body-secondary.rounded.btn-transparent
    .nav-link
      = fa_icon :magnifying_glass, class: 'fa-lg', data:, title:, role: 'button'
SLIM
