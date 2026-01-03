# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

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
