# frozen_string_literal: true

Schematics::Navbar::OnlineUsersCenter::SLIM = <<~SLIM
  li.nav-item.dropdown.d-flex.align-items-center.px-2.ms-2.bg-body-secondary.rounded.btn-transparent
    a#online-users-dropdown.nav-link.dropdown-toggle {
      aria-expanded='false'
      data-bs-toggle='dropdown'
      role='button'
    }
      .position-relative
        = fa_icon icon, class: 'fa-lg'
        .badge.bg-primary.rounded-pill.position-absolute.top-0.start-100.translate-middle.animate__animated.animate__zoomIn
          = sessions.size
    .dropdown-menu.shadow-sm.dropdown-menu-end.animate__animated.animate__zoomIn.p-0.mt-2 {
      aria-labelledby='online-users-dropdown'
    }
      h5.dropdown-header.rounded-top.bg-body-tertiary.fw-bold
        = t('.title')
      .pre-scrollable.overflow-scroll
        = __navbar_online_users_center_preview(sessions)
SLIM
