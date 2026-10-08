# frozen_string_literal: true

Schematics::Sidebar::SLIM = <<~SLIM
  .col.bg-pattern-primary.sidebar data-controller='sidebar' class=('toggled' if preferences_sidebar_toggled)
    .sidebar-sticky.sticky-top.overflow-x-hidden.overflow-y-auto
      .sidebar-brand.fs-5.fw-bolder.text-uppercase.d-flex.align-items-center.text-white.text-nowrap.justify-content-center
        = company_name
      ul.nav.flex-column.flex-nowrap.overflow-y-auto
        li.nav-item.mb-3
        = __sidebar_item(model_classes)
      button#sidebar-toggle.btn.text-secondary.text-end.py-3.w-100 data-action='click->sidebar#toggle'
        .d-none.me-3 class=('d-md-block' unless preferences_sidebar_toggled)
          = fa_icon :chevron_left, class: 'fa-lg'
        .d-none.me-3 class=('d-md-block' if preferences_sidebar_toggled)
          = fa_icon :chevron_right, class: 'fa-lg'
SLIM
