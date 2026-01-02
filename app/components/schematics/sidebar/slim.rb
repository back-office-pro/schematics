# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

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
