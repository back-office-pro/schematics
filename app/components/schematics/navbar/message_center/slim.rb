# frozen_string_literal: true

Schematics::Navbar::MessageCenter::SLIM = <<~SLIM
  li.nav-item.dropdown.d-flex.align-items-center.px-2.ms-2.bg-body-secondary.rounded.btn-transparent
    a#messages-dropdown.nav-link.dropdown-toggle {
      aria-expanded='false'
      data-bs-toggle='dropdown'
      role='button'
    }
      .position-relative
        = fa_icon icon, class: icon_class
        - if count.positive?
          .badge.bg-danger.rounded-pill.position-absolute.top-0.start-100.translate-middle.animate__animated.animate__zoomIn
            = display_count
    .dropdown-menu.shadow-sm.dropdown-menu-end.animate__animated.animate__zoomIn.p-0.mt-2 {
      aria-labelledby='messages-dropdown'
    }
      h5.dropdown-header.rounded-top.bg-body-tertiary.fw-bold
        = t('.title')
      .pre-scrollable.overflow-scroll
        = __navbar_message_center_preview(messages)
      = link_to t('.show_all'), messages_path, class: 'dropdown-item text-body-secondary text-center small'
SLIM
