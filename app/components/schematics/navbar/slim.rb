# frozen_string_literal: true

Schematics::Navbar::SLIM = <<~SLIM
  nav.navbar.navbar-expand.bg-body-tertiary.p-0.sticky-top
    = __navbar_breadcrumb_trail
    ul.navbar-nav.ms-auto.p-2
      = __navbar_notification_center
      = __navbar_message_center
      = __navbar_task_center
      = __navbar_meeting_center
      = __navbar_search_bar
      = __navbar_switch_theme
      = __navbar_online_users_center
      = __navbar_my_account
SLIM
