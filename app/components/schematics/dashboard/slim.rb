# frozen_string_literal: true

Schematics::Dashboard::SLIM = <<~SLIM
  - if dashboards.many?
    .nav.nav-underline.nav-justified.mb-3 role='tablist'
      = __dashboard_tab(dashboards)
  .tab-content
    = __dashboard_panel(dashboards)
SLIM
