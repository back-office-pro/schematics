# frozen_string_literal: true

Schematics::Viewer::Pagination::SLIM = <<~SLIM
  .row.pt-3
    .col.d-none.d-xl-flex.text-secondary.ms-2.align-items-center.align-self-start
      == limit_tag_js(item_name: human_name_plural) if human_name_plural
    .col.d-flex.align-items-center.flex-column
      div class=css_classes == series_nav(:bootstrap) if pages?
      == calendar[:month].series_nav(:bootstrap) if calendar?
    .col.d-none.d-xl-flex.text-secondary.me-2.align-items-center.justify-content-end.align-self-start
      == info_tag(item_name: human_name_plural) if human_name_plural
SLIM
