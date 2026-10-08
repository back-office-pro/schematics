# frozen_string_literal: true

Schematics::Navbar::NotificationCenter::SLIM = <<~SLIM
  li.nav-item.dropdown.d-flex.align-items-center.px-2.bg-body-secondary.rounded.btn-transparent data-controller='notification-center'
    a#notifications-dropdown.nav-link.dropdown-toggle {
      aria-expanded='false'
      data-bs-toggle='dropdown'
      role='button'
      data-action='click->notification-center#readNotifications'
    }
      .position-relative
        = fa_icon icon, data: { 'notification-center-target': 'icon' }, class: icon_class
        - if count.positive?
          .badge.bg-danger.rounded-pill.position-absolute.top-0.start-100.translate-middle.animate__animated.animate__zoomIn {
            data-notification-center-target='badge'
          }
            = display_count
    .dropdown-menu.shadow-sm.dropdown-menu-end.animate__animated.animate__zoomIn.p-0.mt-2 {
      aria-labelledby='notifications-dropdown'
    }
      h5.dropdown-header.rounded-top.bg-body-tertiary.fw-bold
        = t('.title')
      .pre-scrollable.overflow-scroll
        - versions.each do |version|
          .dropdown-item
            = __version_preview(version:)
      = link_to t('.show_all'), versions_path, class: 'dropdown-item text-body-secondary text-center small'
SLIM
