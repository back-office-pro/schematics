# frozen_string_literal: true

Schematics::Navbar::BreadcrumbTrail::SLIM = <<~SLIM
  nav.d-none.d-xl-block.text-truncate aria-label='breadcrumb'
    ol.breadcrumb.ps-3.mb-0.flex-nowrap
      li.breadcrumb-item
        = link_to fa_icon(:house, class: 'fa-lg'), root_path, title:, data:
      = __navbar_breadcrumb_trail_breadcrumb(breadcrumb_trail)
SLIM
