# frozen_string_literal: true

Schematics::Filter::Range::Bound::SLIM = <<~SLIM
  = public_send field_tag,
                filter_name,
                value,
                placeholder: t(".placeholder.\#{comparison}"),
                data:,
                form:,
                class: css_classes
  - if unit
    .input-group-text.bg-transparent.p-0.ps-2
      = unit
SLIM
