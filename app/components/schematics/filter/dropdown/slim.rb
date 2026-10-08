# frozen_string_literal: true

Schematics::Filter::Dropdown::SLIM = <<~SLIM
  .input-group.flex-nowrap
    = select_tag filter_name,
                 options_for_select(collection, value),
                 prompt: t('.prompt', attribute_name:),
                 data:,
                 form:,
                 class: css_classes
SLIM
