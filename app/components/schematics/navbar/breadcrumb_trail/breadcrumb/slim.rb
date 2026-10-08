# frozen_string_literal: true

Schematics::Navbar::BreadcrumbTrail::Breadcrumb::SLIM = <<~SLIM
  li.breadcrumb-item.text-truncate class=css_classes
    = link_to_unless last?, @title, @path, { class: 'text-decoration-none', 'aria-current': ('page' if last?) }
SLIM
