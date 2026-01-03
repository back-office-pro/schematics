# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

Schematics::Viewer::Migrator::SLIM = <<~SLIM
  .card.shadow-sm.animate__animated.animate__zoomIn
    .card-header.px-1.py-2
      = __card_heading(icon:, title:)
    .card-body.p-0
      ul.list-group.list-group-striped
        = __viewer_specifications_section(migrator_build_commands, icon: :plus, item_class: 'text-success')
        = __viewer_specifications_section(migrator_clean_commands, icon: :minus, item_class: 'text-danger')
SLIM
