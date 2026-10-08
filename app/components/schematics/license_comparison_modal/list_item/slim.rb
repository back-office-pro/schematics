# frozen_string_literal: true

Schematics::LicenseComparisonModal::ListItem::SLIM = <<~SLIM
  li.list-group-item.rounded class=css_class
    = fa_icon icon, class: 'me-2'
    span.me-1 = count if count && !zero?
    span = text
SLIM
